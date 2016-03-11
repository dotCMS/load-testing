<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.dotmarketing.business.*" %>
<%@ page import = "com.dotmarketing.factories.*" %>
<%@ page import = "com.dotmarketing.cache.FieldsCache" %>
<%@ page import = "com.dotmarketing.portlets.categories.business.*" %>
<%@ page import = "com.dotmarketing.portlets.categories.model.*" %>
<%@ page import = "com.dotmarketing.portlets.contentlet.model.Contentlet" %>
<%@ page import = "com.dotmarketing.portlets.contentlet.business.ContentletAPI" %>
<%@ page import = "com.dotmarketing.portlets.contentlet.business.HostAPI" %>
<%@ page import = "com.dotmarketing.portlets.containers.model.*" %>
<%@ page import = "com.dotmarketing.portlets.folders.business.*" %>
<%@ page import = "com.dotmarketing.portlets.folders.model.*" %>
<%@ page import = "com.dotmarketing.portlets.templates.business.*" %>
<%@ page import = "com.dotmarketing.portlets.structure.factories.*" %>
<%@ page import = "com.dotmarketing.portlets.structure.model.*" %>
<%@ page import = "com.dotmarketing.portlets.templates.model.*" %>
<%@ page import = "com.dotmarketing.beans.*" %>
<%@ page import = "com.dotmarketing.exception.*" %>
<%@ page import = "com.liferay.portal.model.User" %>
<%@ page import = "com.liferay.util.FileUtil" %>
<%@ page import = "javax.xml.parsers.SAXParser" %>
<%@ page import = "javax.xml.parsers.SAXParserFactory" %>
<%@ page import = "org.xml.sax.Attributes" %>
<%@ page import = "org.xml.sax.SAXException" %>
<%@ page import = "org.xml.sax.helpers.DefaultHandler" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileNotFoundException" %>

<%
	out.println("<b>Beginning QA data creation...</b> <br/><br/>");
	out.flush();
	out.println("<b>&nbsp;&nbsp;&nbsp;&nbsp;Beginning initialization code</b> <br/>");
	out.flush();

	HostAPI hostApi = APILocator.getHostAPI();
	UserAPI userApi = APILocator.getUserAPI();
	FolderAPI folderApi = APILocator.getFolderAPI();
	User systemUser = userApi.getSystemUser();
	User adminUser = null;
	List<User> userList = userApi.getUsersByNameOrEmailOrUserID("dotcms.org.1", 1, 1000);
	for(User user : userList) {
		if ("Admin".equals(user.getFirstName()) && ("User".equals(user.getLastName())) && ("admin@dotcms.com".equals(user.getEmailAddress()))) {
			adminUser = user;
			break;
		}
	}
	System.out.println("adminUser=" + adminUser);
	if(adminUser != null) {
		System.out.println("adminUser.getUserId()=" + adminUser.getUserId());
	}
	Host systemHost = hostApi.findSystemHost();
	out.println("<b>&nbsp;&nbsp;&nbsp;&nbsp;Finished initialization code</b><br/>");


	out.println("<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Host Creation</b><br/>");
	out.flush();
	createHostIfDoesNotExist("demo.dotcms.com", systemUser, false);

	List<Host> hosts = hostApi.findAll(systemUser, false);
	for(Host host : hosts) {
		out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hostName = " + host.getHostname() +"<br/>");
	}
	

	out.println("<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Folder Creation</b><br/>");
	out.flush();
	Host demoHost = hostApi.findByName("demo.dotcms.com", systemUser, false);
	Folder reutersNewsFolder = folderApi.createFolders("/reutersnews/", demoHost, systemUser, false);
	System.out.println("reutersNewsFolder.getHostId() = " + reutersNewsFolder.getHostId());


	out.println("<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Asset Creation</b><br/>");
	out.flush();
	Contentlet vtlFile = null;
	Contentlet vtlWidget = null;
	Contentlet htmlPage = null;
	try {
		String filename = "/Users/brent/dotcms/repos/autotest/load-testing/reutersnewsstoryload/contentForInitialLoading/qashared.dotcms.com/vtl/widgets/reuters-news-detail-body.vtl";
		vtlFile = createFileAsset(filename, "demo.dotcms.com", reutersNewsFolder.getInode(), 1, "reuters-news-detail-body.vtl", adminUser);
		vtlWidget = createVTLIncludeWidget("reutersNewsWidget", "demo.dotcms.com", vtlFile.getIdentifier(), 1, adminUser);
		Template template = getTemplateByTitle(demoHost, "Quest - 1 Column");
		htmlPage = createHTMLPage("detail page", template.getIdentifier() , "demo.dotcms.com", reutersNewsFolder.getInode(), 1, adminUser);
		Container container = findContainerByTitle(demoHost, "Large Column (lg-1)");
		MultiTree tree = new MultiTree(htmlPage.getIdentifier(), container.getIdentifier(), vtlWidget.getIdentifier());
		MultiTreeFactory.saveMultiTree(tree, 1);
	}
	catch (Exception e) {
		e.printStackTrace();
		out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ERROR  - " + e.getMessage());
		out.flush();
	}


	/*
	out.println("<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Container and Template Creation</b><br/>");
	out.flush();

	Container container1 = createDefaultContainerIfDoesNotExist("QA Default Container 1", systemUser, qaSharedHost);	
	createTemplateIfDoesNotExist("QA Blank Template", "QA Blank Template Friendly Name", qaSharedHost, systemUser, containerList);
	*/


	out.println("<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Reuters Category Creation</b><br/>");
	out.flush();
	Category topicsParent = createCategoryIfDoesNotExist(null, "QA Reuters Topics", "QAReutersTopics", "qareuterstopics", "qareuterstopics", systemUser);
	createSubCategoriesFromFile(topicsParent, "/Users/brent/dotcms/repos/autotest/load-testing/reutersnewsstoryload/Reuters21578/all-topics-strings.lc.txt", systemUser);
	Category placesParent = createCategoryIfDoesNotExist(null, "QA Reuters Places", "QAReutersPlaces", "qareutersplaces", "qareuterplaces", systemUser);
	createSubCategoriesFromFile(placesParent, "/Users/brent/dotcms/repos/autotest/load-testing/reutersnewsstoryload/Reuters21578/all-places-strings.lc.txt", systemUser);
	Category peopleParent = createCategoryIfDoesNotExist(null, "QA Reuters People", "QAReutersPeople", "qareuterspeople", "qareuterspeople", systemUser);
	createSubCategoriesFromFile(peopleParent, "/Users/brent/dotcms/repos/autotest/load-testing/reutersnewsstoryload/Reuters21578/all-people-strings.lc.txt", systemUser);
	Category orgsParent = createCategoryIfDoesNotExist(null, "QA Reuters Orgs", "QAReutersOrgs", "qareutersorgs", "qareutersorgs", systemUser);
	createSubCategoriesFromFile(orgsParent, "/Users/brent/dotcms/repos/autotest/load-testing/reutersnewsstoryload/Reuters21578/all-orgs-strings.lc.txt", systemUser);
	Category exchangesParent = createCategoryIfDoesNotExist(null, "QA Reuters Exchanges", "QAReutersExchanges", "qareutersexchange", "qareutersexchanges", systemUser);
	createSubCategoriesFromFile(exchangesParent, "/Users/brent/dotcms/repos/autotest/load-testing/reutersnewsstoryload/Reuters21578/all-exchanges-strings.lc.txt", systemUser);


	out.println("<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Create Reuters News Structure</b><br/>");
	out.flush();
	String detailPageIdentifier = "";
	if(htmlPage != null)
		detailPageIdentifier = htmlPage.getIdentifier();
	Structure reuterStruct = createReutersNewsStructureIfDoesNotExist(detailPageIdentifier);


	out.println("<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Load Reuters News Articles</b><br/>");
	out.flush();
	createReutersNewsArticles("/Users/brent/dotcms/repos/autotest/load-testing/reutersnewsstoryload/Reuters21578/reuters21578.xml");


	out.println("<b><br/>Finished QA data creation</b>");
	out.flush();
%>


<%!
public Contentlet createHTMLPage(String title, String templateIdentifer, String hostName, String folderInode, int languageId, User user) throws Exception {
	ContentletAPI conAPI = APILocator.getContentletAPI();
	Contentlet con = new Contentlet();
	con.setStructureInode(StructureFactory.getStructureByVelocityVarName("htmlpageasset").getInode());
	con.setHost(hostName);
	con.setStringProperty("title", title);
	String urlTitle = title.toLowerCase();
	urlTitle = urlTitle.replaceAll("^\\s+|\\s+$", "");
	urlTitle = urlTitle.replaceAll("[^a-zA-Z 0-9]", " ");
	urlTitle = urlTitle.replaceAll("\\s", "-");
	urlTitle = urlTitle.replaceAll("--", "-");
	while(urlTitle.lastIndexOf("-") == urlTitle.length() -1 ){
		urlTitle=urlTitle.substring(0,urlTitle.length() -1);
	}
	con.setStringProperty("url", urlTitle);
	con.setStringProperty("friendlyname", title);
	con.setStringProperty("template", templateIdentifer);
	con.setStringProperty("cachettl", "15");
	con.setFolder(folderInode);
	con.setLanguageId(languageId);
	con = conAPI.checkin(con, user, false);
	conAPI.publish(con, user, false);
	return con;
}

public Contentlet createVTLIncludeWidget(String title, String hostName, String vtlFileIdentifier, int languageId, User user) throws Exception {
	ContentletAPI conAPI = APILocator.getContentletAPI();
	Contentlet con = new Contentlet();
	con.setStructureInode(StructureFactory.getStructureByVelocityVarName("VtlInclude").getInode());
	con.setHost(hostName);
	con.setStringProperty("widgetTitle", title);
	con.setStringProperty("vtlFile", vtlFileIdentifier);
	con.setLanguageId(languageId);
	con = conAPI.checkin(con, user, false);
	conAPI.publish(con, user, false);
	return con;
}

public Contentlet createFileAsset(String fullFilename, String hostName, String folderInode, int languageId, String title, User user) throws Exception {
	java.io.File srcFile = new java.io.File(fullFilename);
	if(!srcFile.exists()) {
		throw new FileNotFoundException("ERROR - file does not exist - " + srcFile.getAbsolutePath());
	}
	java.io.File tmpFile = File.createTempFile("temp", null);
	System.out.println("tmpFile.getParent()=" + tmpFile.getParent());
	System.out.println("srcFile.getName()=" + srcFile.getName());

	java.io.File destFile = new File(tmpFile.getParent(), srcFile.getName());
	System.out.println("destFile.getAbsolutePath()=" + destFile.getAbsolutePath());
	FileUtil.copyFile(srcFile, destFile);
	Structure fileStruct = StructureFactory.getStructureByVelocityVarName("FileAsset");
	ContentletAPI conAPI = APILocator.getContentletAPI();
	Contentlet con = new Contentlet();
	con.setStructureInode(fileStruct.getInode());
	con.setHost(hostName);
	con.setFolder(folderInode);
	con.setStringProperty("fileName", srcFile.getName());
	con.setLanguageId(languageId);
	con.setStringProperty("title", title);
	con.setBinary("fileAsset", destFile);
	con = conAPI.checkin(con, user, false);
	conAPI.publish(con, user, false);
	return con;
}

public void createSubCategoriesFromFile(Category parent, String filename, User user) {
	java.io.BufferedReader br = null;
	String line = null;
	try{
		br = new java.io.BufferedReader(new java.io.FileReader(filename));
		while((line = br.readLine()) != null) {
			if(!line.trim().isEmpty()) {
				createCategoryIfDoesNotExist(parent, line, line, line, line, user);
			}
		}
	}
	catch(Exception e) {
		e.printStackTrace();
	}
	finally{
		if(br != null){
			try{
				br.close();
			}
			catch(java.io.IOException e){
				br = null;
				e.printStackTrace();
			}
		}
	}

}
public Category createCategoryIfDoesNotExist(Category parent, String name, String key, String velocityVarName, String keyWords, User user) throws DotDataException, DotSecurityException {
	Category retValue = null;
	List<Category> catList = null;
	if(parent != null)
		catList = APILocator.getCategoryAPI().findChildren(user, parent.getInode(), false, key);
	else
		catList = APILocator.getCategoryAPI().findTopLevelCategories(user, false, key);
	for(Category cat : catList) {
		if(cat.getCategoryName().equals(name) && cat.getKey().equals(key) && cat.getCategoryVelocityVarName().equals(velocityVarName) && cat.getKeywords().equals(keyWords)) {
			retValue = cat;
		}
	}
	if(retValue == null) {
		Category cat = new Category();
		cat.setCategoryName(name);
		cat.setKey(key);
		cat.setCategoryVelocityVarName(velocityVarName);
		cat.setKeywords(keyWords);
		APILocator.getCategoryAPI().save(parent, cat, user, false);
		retValue = cat;
	}
	return retValue;
}

public Exception createHostIfDoesNotExist(String hostName, User user, boolean respectFrontendRoles) {
	Exception retValue = null;
	try {
		HostAPI hostAPI = APILocator.getHostAPI();
		Host host = hostAPI.findByName(hostName, user, respectFrontendRoles);
		if(host == null) {
			host = new Host();
			host.setHostname(hostName);
			host = hostAPI.save(host, user, respectFrontendRoles);
		}	
		
		hostAPI.publish(host, user, respectFrontendRoles);

	}
	catch(Exception e) {
		retValue = e;
	}
	return retValue;
}

public Container createDefaultContainerIfDoesNotExist(String title, User user, Host host) throws DotDataException, DotSecurityException, WebAssetException {
	Container retValue = findContainerByTitle(host, title);
	
	if(retValue == null) {
		retValue = new Container();
		retValue.setTitle(title);
		retValue.setFriendlyName("Displays page content");
		retValue.setMaxContentlets(25);
		//retValue.setStructureInode(StructureFactory.getDefaultStructure().getInode());
		retValue.setCode("#dotedit($CONTENT_INODE, $body)\r\n");
		retValue.setNotes("This container display the body field of the content type Page Content.");
		WebAssetFactory.createAsset(retValue, user.getUserId(), host);
		PublishFactory.publishAsset(retValue, user, false);
	}
	return retValue;
}

public Template createTemplateIfDoesNotExist(String title, String description, Host host, User user, List<Container> containerList) throws DotDataException, DotHibernateException, DotSecurityException, WebAssetException {
	Template retValue = getTemplateByTitle(host, title);
	
	if(retValue == null) {
		TemplateAPI templateAPI = APILocator.getTemplateAPI();
		Template blankTemplate = new Template();
		blankTemplate.setTitle(title);
		blankTemplate.setFriendlyName(description);
		String body = "";
		for(Container cont : containerList) {
			body = body + "## This is autogenerated code that cannot be changed\r\n#parseContainer('" + cont.getIdentifier() +"')\r\n";			
		}
		blankTemplate.setBody(body);
		Template savedTemplate = templateAPI.saveTemplate(blankTemplate, host, user, false);
		templateAPI.associateContainers(containerList, blankTemplate);
		PublishFactory.publishAsset(savedTemplate, user, false);
		retValue = savedTemplate;
	}
	
	return retValue;
}

public Template getTemplateByTitle(Host host, String title) throws DotDataException, DotSecurityException {
	Template retValue = null;
	TemplateAPI templateAPI = APILocator.getTemplateAPI();
	List<Template> templateList = templateAPI.findTemplatesAssignedTo(host);
	for(Template temp : templateList) {
		if(temp.getTitle().equals(title) && !temp.isArchived()) {
			retValue = temp;
			break;
		}
	}
	return retValue;
}

public Container findContainerByTitle(Host host, String title) throws DotDataException, DotSecurityException{
	Container retValue = null;
	List<Container> containerList = APILocator.getContainerAPI().findContainersUnder(host);
	for(Container cont : containerList) {
		if(cont.getTitle().equals(title) && cont.isArchived() == false) {
			retValue = cont;
			break;
		}
	}
	return retValue;
}

public Structure createReutersNewsStructureIfDoesNotExist(String detailPageIdentifier)  throws DotHibernateException {
String structureVarname = "reutersnews";
	String structureDesc = "Reuters News Desc";

	Structure reutersStruct = StructureFactory.getStructureByVelocityVarName(structureVarname);
	if((structureDesc.equals(reutersStruct.getDescription()))) {
		System.out.println("*** Reuters structure already exists ***");
	}
	else {
		System.out.println("*** Creating reuters structure ***");
		reutersStruct.setName(structureVarname);
		reutersStruct.setVelocityVarName(structureVarname);
		reutersStruct.setDescription(structureDesc);
		reutersStruct.setDefaultStructure(false);
		reutersStruct.setFixed(false);
		reutersStruct.setDetailPage(detailPageIdentifier);
		reutersStruct.setUrlMapPattern("/reutersnews/{urlTitle}");
		StructureFactory.saveStructure(reutersStruct);

		Field field = new Field();
		field.setDefaultValue("");
		field.setFieldContentlet("text1");
		field.setFieldName("title");
		field.setFieldType(Field.FieldType.TEXT.toString());
		field.setHint("");
		field.setRegexCheck("");
		field.setRequired(true);
		field.setSortOrder(0);
		field.setStructureInode(reutersStruct.getInode());
		field.setFieldRelationType("");
		field.setVelocityVarName("title");
		field.setIndexed(true);
		field.setSearchable(true);
		field.setListed(true);
		field.setFixed(false);
		field.setReadOnly(false);
		FieldFactory.saveField(field);

		field = new Field();
		field.setDefaultValue("");
		field.setFieldContentlet("text2");
		field.setFieldName("urltitle");
		field.setFieldType(Field.FieldType.TEXT.toString());
		field.setHint("");
		field.setRegexCheck("");
		field.setRequired(true);
		field.setSortOrder(1);
		field.setStructureInode(reutersStruct.getInode());
		field.setFieldRelationType("");
		field.setVelocityVarName("urltitle");
		field.setIndexed(true);
		field.setSearchable(true);
		field.setListed(true);
		field.setFixed(false);
		field.setReadOnly(false);
		FieldFactory.saveField(field);

		field = new Field();
		field.setDefaultValue("");
		field.setFieldContentlet("date1");
		field.setFieldName("publishdate");
		field.setFieldType(Field.FieldType.DATE.toString());
		field.setHint("");
		field.setRegexCheck("");
		field.setRequired(false);
		field.setSortOrder(2);
		field.setStructureInode(reutersStruct.getInode());
		field.setFieldRelationType("");
		field.setVelocityVarName("publishdate");
		field.setIndexed(false);
		field.setSearchable(false);
		field.setListed(false);
		field.setFixed(false);
		field.setReadOnly(false);
		FieldFactory.saveField(field);

		field = new Field ();
		field.setDefaultValue("");
		field.setFieldContentlet("text_area1");
		field.setFieldName("body");
		field.setFieldType(Field.FieldType.TEXT_AREA.toString());
		field.setHint("");
		field.setRegexCheck("");
		field.setRequired(true);
		field.setSortOrder(3);
		field.setStructureInode(reutersStruct.getInode());
		field.setFieldRelationType("");
		field.setVelocityVarName("body");
		field.setIndexed(true);
		field.setSearchable(true);
		field.setListed(false);
		field.setFixed(false);
		field.setReadOnly(false);
		FieldFactory.saveField(field);

		field = new Field ();
		field.setDefaultValue("");
		field.setFieldContentlet("system_field1");
		field.setFieldName("host");
		field.setFieldType(Field.FieldType.HOST_OR_FOLDER.toString());
		field.setHint("");
		field.setRegexCheck("");
		field.setRequired(true);
		field.setSortOrder(4);
		field.setStructureInode(reutersStruct.getInode());
		field.setFieldRelationType("");
		field.setVelocityVarName("host1");
		field.setIndexed(false);
		field.setSearchable(false);
		field.setListed(false);
		field.setFixed(false);
		field.setReadOnly(false);
		FieldFactory.saveField(field);

		FieldsCache.clearCache();
	}

	return reutersStruct;
}

public void createReutersNewsArticles(String filename) {
	try {
		SAXParserFactory factory = SAXParserFactory.newInstance();
		SAXParser saxParser = factory.newSAXParser();
		System.out.println("saxParser - name =" + saxParser.getClass().getName());
		System.out.println("saxParser - simple name =" + saxParser.getClass().getSimpleName());
		System.out.println("saxParser - canonical name =" + saxParser.getClass().getCanonicalName());
		
		DefaultHandler handler = new DefaultHandler() {
			ContentletAPI conAPI = APILocator.getContentletAPI();
			User systemUser = APILocator.getUserAPI().getSystemUser();
			User adminUser = null;
			Structure struct = StructureFactory.getStructureByVelocityVarName("reutersnews");
			Host host = APILocator.getHostAPI().findByName("qademo.dotcms.com", systemUser, false);
			Host systemHost = APILocator.getHostAPI().findSystemHost();

			int articleCount = 0;
			Category topicsCategory = null;
			Category placesCategory = null;
			Category peopleCategory = null;
			Category orgsCategory = null;
			Category exchangesCategory = null;
			boolean inArticle = false;
			boolean inTopics = false;
			boolean inPlaces = false;
			boolean inPeople = false;
			boolean inOrgs = false;
			boolean inExchanges = false;
			boolean inTitle = false;
			String title = "";
			boolean inBody = false;
			String body = "";
			boolean inD = false;
			ArrayList<Category> categories = new ArrayList<Category>();
		
			{
				System.out.println("qadataload - struct = " + struct);

				List<User> userList = APILocator.getUserAPI().getUsersByNameOrEmailOrUserID("dotcms.org.1", 1, 1000);
				for(User user : userList) {
					if ("Admin".equals(user.getFirstName()) && ("User".equals(user.getLastName())) && ("admin@dotcms.com".equals(user.getEmailAddress()))) {
						adminUser = user;
						break;
					}
				}

				System.out.println("adminUser = " + adminUser);
				CategoryAPI catapi = APILocator.getCategoryAPI();
				List<Category> toplevelcats = catapi.findTopLevelCategories(systemUser, false, "QA Reuters");
				for(Category cat : toplevelcats) {
					System.out.println("qadataload - cat.getCategoryName() = " + cat.getCategoryName());
					if("QA Reuters Topics".equals(cat.getCategoryName())) {
						topicsCategory = cat;
					}
					else if("QA Reuters Places".equals(cat.getCategoryName())) {
						placesCategory = cat;
					}
					else if("QA Reuters People".equals(cat.getCategoryName())) {
						peopleCategory = cat;
					}
					else if("QA Reuters Orgs".equals(cat.getCategoryName())) {
						orgsCategory = cat;
					}
					else if("QA Reuters Exchanges".equals(cat.getCategoryName())) {
						exchangesCategory = cat;
					}
				}
				System.out.println("qadataload - topicsCategory = " + topicsCategory);
				System.out.println("qadataload - placesCategory = " + placesCategory);
				System.out.println("qadataload - peopleCategory = " + peopleCategory);
				System.out.println("qadataload - orgsCategory = " + orgsCategory);
				System.out.println("qadataload - exchangesCategory = " + exchangesCategory);
			}
			
			public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
				if (qName.equals("REUTERS")) {
					inArticle = true;
				}
				else if(qName.equals("TOPICS")) {
					inTopics = true;
				}
				else if(qName.equals("PLACES")) {
					inPlaces = true;
				}
				else if(qName.equals("PEOPLE")) {
					inPeople = true;
				}
				else if(qName.equals("ORGS")) {
					inOrgs = true;
				}
				else if(qName.equals("EXCHANGES")) {
					inExchanges = true;
				} 
				else if(qName.equals("TITLE")) {
					inTitle = true;
				}
				else if(qName.equals("BODY")) {
					inBody = true;
				} 
				else if (qName.equals("D")) {
					inD = true;
				}
			}
		
			public void endElement(String uri, String localName, String qName) throws SAXException {
				if (qName.equalsIgnoreCase("REUTERS")) {
					
					Contentlet con = new Contentlet();
					con.setStructureInode(struct.getInode());
					con.setHost(systemHost.getIdentifier());
					con.setLanguageId(1);

					if(title.isEmpty())
						title = "<No Title>";
					con.setStringProperty("title", title);
					System.out.println("qadataload - title = " + con.getTitle());
					
					String urlTitle = title.toLowerCase();
					urlTitle = urlTitle.replaceAll("^\\s+|\\s+$", "");
					urlTitle = urlTitle.replaceAll("[^a-zA-Z 0-9]", " ");
					urlTitle = urlTitle.replaceAll("\\s", "-");
					urlTitle = urlTitle.replaceAll("--", "-");
				    while(urlTitle.lastIndexOf("-") == urlTitle.length() -1 ){
				      urlTitle=urlTitle.substring(0,urlTitle.length() -1);
				    }
					System.out.println("qadataload - urlTitle = " + urlTitle);
					con.setStringProperty("urltitle", urlTitle);
					
					con.setDateProperty("publishdate", new Date());
					if(body.isEmpty())
						body = "<No Body>";
					con.setStringProperty("body", body);
					try{
						con = conAPI.checkin(con, adminUser, false, categories);
						conAPI.publish(con, adminUser, false);
					}
					catch (Exception e) {
						System.out.println("******** qadataload - ERROR - title = " + title + " ********");
						e.printStackTrace();
					}
					finally {
						articleCount++;
						inArticle = false;
						title = "";
						body = "";
						categories = new ArrayList<Category>();
					}
				}
				else if(qName.equals("TOPICS")) {
					inTopics = false;
				}
				else if(qName.equals("PLACES")) {
					inPlaces = false;
				}
				else if(qName.equals("PEOPLE")) {
					inPeople = false;
				}
				else if(qName.equals("ORGS")) {
					inOrgs = false;
				}
				else if(qName.equals("EXCHANGES")) {
					inExchanges = false;
				}  
				else if(qName.equals("TITLE")) {
					inTitle = false;
				}
				else if(qName.equals("BODY")) {
					inBody = false;
				} 
				else if (qName.equals("D")) {
					inD = false;
				}
			}
		
			public void characters(char ch[], int start, int length) throws SAXException {
				String chars = new String(ch, start, length);
				String charsTrimmed = chars.trim();
				int lengthTrimmed = charsTrimmed.length();
			
				if(inTitle && lengthTrimmed > 0) {
					title += chars;
				}
				else if(inBody && lengthTrimmed > 0) {
					body += chars;
				}
				else if(inD && lengthTrimmed > 0) {
					if(inTopics) {
						addChildCategory(chars, topicsCategory.getInode());
					}
					else if(inPlaces) {
						addChildCategory(chars, placesCategory.getInode());
					}
					else if(inPeople) {
						addChildCategory(chars, peopleCategory.getInode());
					}
					else if(inOrgs) {
						addChildCategory(chars, orgsCategory.getInode());
					}
					else if(inExchanges) {
						addChildCategory(chars, exchangesCategory.getInode());
					}
				}
			}
			
			private void addChildCategory(String childCategoryName, String parentCategoryInode) {
				try {
					List<Category> children = APILocator.getCategoryAPI().findChildren(adminUser, parentCategoryInode, false, childCategoryName);
					for(Category cat : children) {
						if(childCategoryName.equals(cat.getCategoryName())) {
							categories.add(cat);
							break;
						}
					}
				}
				catch (Exception e) {
					System.out.println("******** qadataload - ERROR - title = " + title + " ********");
					e.printStackTrace();
				}
			}
		};

		saxParser.parse(new java.io.File(filename), handler);

//		System.out.println("articleCount=" + new Integer(articleCount));

	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("ERROR - " + e.getLocalizedMessage());
	}
}
%>