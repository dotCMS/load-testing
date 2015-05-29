<%@ page language = "java" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dotmarketing.business.*" %>
<%@ page import = "com.dotmarketing.factories.*" %>
<%@ page import = "com.dotmarketing.portlets.categories.business.*" %>
<%@ page import = "com.dotmarketing.portlets.categories.model.*" %>
<%@ page import = "com.dotmarketing.portlets.contentlet.model.Contentlet" %>
<%@ page import = "com.dotmarketing.portlets.contentlet.business.ContentletAPI" %>
<%@ page import = "com.dotmarketing.portlets.contentlet.business.HostAPI" %>
<%@ page import = "com.dotmarketing.portlets.containers.model.*" %>
<%@ page import = "com.dotmarketing.portlets.folders.business.*" %>
<%@ page import = "com.dotmarketing.portlets.folders.model.*" %>
<%@ page import = "com.dotmarketing.portlets.htmlpages.business.HTMLPageAPI" %>
<%@ page import = "com.dotmarketing.portlets.htmlpages.model.HTMLPage" %>
<%@ page import = "com.dotmarketing.portlets.languagesmanager.model.Language"%>
<%@ page import = "com.dotmarketing.portlets.templates.business.*" %>
<%@ page import = "com.dotmarketing.portlets.structure.factories.*" %>
<%@ page import = "com.dotmarketing.portlets.structure.model.*" %>
<%@ page import = "com.dotmarketing.portlets.templates.model.*" %>
<%@ page import = "com.dotmarketing.beans.*" %>
<%@ page import = "com.dotmarketing.exception.*" %>
<%@ page import = "com.liferay.portal.model.User" %>
<%@ page import = "javax.xml.parsers.SAXParser" %>
<%@ page import = "javax.xml.parsers.SAXParserFactory" %>
<%@ page import = "org.apache.commons.io.FileUtils" %>
<%@ page import = "org.xml.sax.Attributes" %>
<%@ page import = "org.xml.sax.SAXException" %>
<%@ page import = "org.xml.sax.helpers.DefaultHandler" %>

<b>Beginning QA data creation...</b> <br/><br/>

<b>&nbsp;&nbsp;&nbsp;&nbsp;Beginning initialization code</b> <br/>
<%
	out.flush();
	ContentletAPI contentletApi = APILocator.getContentletAPI();
	HostAPI hostApi = APILocator.getHostAPI();
	UserAPI userApi = APILocator.getUserAPI();
	FolderAPI folderApi = APILocator.getFolderAPI();
	User systemUser = userApi.getSystemUser();
	Host systemHost = hostApi.findSystemHost();
%>
<b>&nbsp;&nbsp;&nbsp;&nbsp;Finished initialization code</b><br/>


<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Widget VTL</b><br/>
<%
	out.flush();
	
	Host qaSharedHost = hostApi.findByName("qashared.dotcms.com", systemUser, false);
	Folder widgetsFieldsVTLFolder = folderApi.createFolders("/vtl/widgetsJBG69-6/", qaSharedHost, systemUser, false);
	
	try{
		File f = new File("/Users/brent/dotcms/testingautomation/contentForInitialLoading/qashared.dotcms.com/vtl/widgets/reuters-news-detail-body.vtl");
		saveAndPublishFileAsset(qaSharedHost, widgetsFieldsVTLFolder, f, systemUser);
		Contentlet widget = saveAndPublishSimpleWidget("Reuters News Detail-JBG69-6", "#dotParse('//qashared.dotcms.com/vtl/widgets/reuters-news-detail-body.vtl')", systemUser);
		
		HTMLPageAPI htmlapi = APILocator.getHTMLPageAPI();
		String ext = ".html";
		HTMLPage htmlPage = new HTMLPage();
		htmlPage.setPageUrl("testpage6"+ext);
		htmlPage.setFriendlyName("testpage6"+ext);
		htmlPage.setTitle("testpage6"+ext);

		Container container = null;
		List<Container> containerList = APILocator.getContainerAPI().findContainersUnder(qaSharedHost);
		for(Container cont : containerList) {
			if(cont.getTitle().equals("QA Default Container 1") && cont.isArchived() == false) {
				container = cont;
				break;
			}
		}

		Template template = null;
		TemplateAPI templateAPI = APILocator.getTemplateAPI();
		List<Template> templateList = templateAPI.findTemplatesAssignedTo(qaSharedHost);
		for(Template temp : templateList) {
			if(temp.getTitle().equals("QA Blank Template") && temp.isArchived() == false) {
				template = temp;
				break;
			}
		}

		htmlPage = APILocator.getHTMLPageAPI().saveHTMLPage(htmlPage, template, widgetsFieldsVTLFolder, systemUser, false);
		PublishFactory.publishAsset(htmlPage, systemUser, false);
		// TODO add code to unlock htmlpage
		
		
		Identifier identifier = APILocator.getIdentifierAPI().find(widget);
		Identifier htmlPageIdentifier = APILocator.getIdentifierAPI().find(htmlPage);
		Identifier containerIdentifier = APILocator.getIdentifierAPI().find(container);

        MultiTree mTree = new MultiTree(htmlPageIdentifier.getInode(),containerIdentifier.getInode(),identifier.getInode());
        MultiTreeFactory.saveMultiTree(mTree);
        
		//Updating the last mod user and last mod date of the page
        htmlPage.setModDate(new Date());
        htmlPage.setModUser(systemUser.getUserId());
	}
	catch(Exception e){
		out.println(e);
	}
	out.flush();
%>	

<b><br/>Finished QA data creation</b>

<%!
public Contentlet saveAndPublishSimpleWidget(String title, String code, User user) {
	Contentlet retValue = null;
	try{
		Language lang = APILocator.getLanguageAPI().getDefaultLanguage();
		Structure fileStruct = StructureFactory.getStructureByVelocityVarName("SimpleWidget");
		Map<String, Object> m = new HashMap<String,Object>();
		m.put("stInode", fileStruct.getInode());
//		m.put("host", host.getIdentifier());
//		m.put("folder", folder.getInode()); // You need the inode of the folder (folders are not versioned)
		m.put("languageId", lang.getId());
		m.put("sortOrder", new Long(0));
		m.put("widgetTitle", title);
	 
		m.put("code", code);

		// create a new piece of content backed by the map created above
		retValue = new Contentlet(m);
		
		// check in the content
		retValue = APILocator.getContentletAPI().checkin(retValue, user, false);
		
		// publish the content
		APILocator.getContentletAPI().publish(retValue, user, false);	
	}
	catch(Exception e){
		System.out.println(e);
	}
	return retValue;
}

public Contentlet saveAndPublishFileAsset(Host host, Folder folder, File fileToSave, User user) {
	Contentlet retValue = null;
	try{
		// Making copy of file because checkin code deletes file when it is finished with it.
		File tmpFile = new File("~/temp/" +fileToSave.getName());
		FileUtils.copyFile(fileToSave, tmpFile);
		Language lang = APILocator.getLanguageAPI().getDefaultLanguage();
		Structure fileStruct = StructureFactory.getStructureByVelocityVarName("FileAsset");
		Map<String, Object> m = new HashMap<String,Object>();
		m.put("stInode", fileStruct.getInode());
		m.put("host", host.getIdentifier());
		m.put("folder", folder.getInode()); // You need the inode of the folder (folders are not versioned)
		m.put("languageId", lang.getId());
		m.put("sortOrder", new Long(0));
		m.put("title", tmpFile.getName());
		m.put("fileName", tmpFile.getName());
	 
		// binary field, pass the (local) file, which will be copied into the content repository
		m.put("fileAsset", tmpFile);

		// create a new piece of content backed by the map created above
		retValue = new Contentlet(m);
		
		// check in the content
		retValue = APILocator.getContentletAPI().checkin(retValue, user, false);
		
		// publish the content
		APILocator.getContentletAPI().publish(retValue, user, false);	
	}
	catch(Exception e){
		System.out.println(e);
	}
	return retValue;
}

%>