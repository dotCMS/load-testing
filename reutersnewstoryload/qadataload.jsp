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
<%@ page import = "com.dotmarketing.portlets.templates.business.*" %>
<%@ page import = "com.dotmarketing.portlets.structure.factories.*" %>
<%@ page import = "com.dotmarketing.portlets.structure.model.*" %>
<%@ page import = "com.dotmarketing.portlets.templates.model.*" %>
<%@ page import = "com.dotmarketing.beans.*" %>
<%@ page import = "com.dotmarketing.exception.*" %>
<%@ page import = "com.liferay.portal.model.User" %>
<%@ page import = "javax.xml.parsers.SAXParser" %>
<%@ page import = "javax.xml.parsers.SAXParserFactory" %>
<%@ page import = "org.xml.sax.Attributes" %>
<%@ page import = "org.xml.sax.SAXException" %>
<%@ page import = "org.xml.sax.helpers.DefaultHandler" %>

<b>Beginning QA data creation...</b> <br/><br/>

<b>&nbsp;&nbsp;&nbsp;&nbsp;Beginning initialization code</b> <br/>
<%
//	APILocator.getESIndexAPI().createIndex("temp", 1);
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
	Host systemHost = hostApi.findSystemHost();
	out.flush();
%>
<b>&nbsp;&nbsp;&nbsp;&nbsp;Finished initialization code</b><br/>

<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Host Creation</b><br/>

<%
	createHostIfDoesNotExist("qademo.dotcms.com", systemUser, false);
	createHostIfDoesNotExist("m.qademo.dotcms.com", systemUser, false);
	createHostIfDoesNotExist("qashared.dotcms.com", systemUser, false);

	List<Host> hosts = hostApi.findAll(systemUser, false);
	for(Host host : hosts) {%>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;hostName = <%=host.getHostname()%><br/>
<%	}
	out.flush();
%>

<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Folder Creation</b><br/>
<%	
	// qademo.dotcms.com
	Host qaDemoHost = hostApi.findByName("qademo.dotcms.com", systemUser, false);
	Folder homeFolder = folderApi.createFolders("/home/", qaDemoHost, systemUser, false);
	Folder qaDemoReuterNewsFolder = folderApi.createFolders("/reuternews/", qaDemoHost, systemUser, false);

	// m.qademo.dotcms.com
	Host mobileQaDemoHost = hostApi.findByName("m.qashared.dotcms.com", systemUser, false);
	Folder mobileQaDemoReuterNewsFolder = folderApi.createFolders("/reuternews/", mobileQaDemoHost, systemUser, false);

	//qashared.dotcms.com
	Host qaSharedHost = hostApi.findByName("qashared.dotcms.com", systemUser, false);
	Folder customFieldsVTLFolder = folderApi.createFolders("/vtl/custom-fields/", qaSharedHost, systemUser, false);
	Folder macrosVTLFolder = folderApi.createFolders("/vtl/macros/", qaSharedHost, systemUser, false);
	Folder widgetsFieldsVTLFolder = folderApi.createFolders("/vtl/widgets/", qaSharedHost, systemUser, false);

	out.flush();
%>	

<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Container and Template Creation</b><br/>
<%
	Container container1 = createDefaultContainerIfDoesNotExist("QA Default Container 1", systemUser, qaSharedHost);
	List<Container> containerList = new ArrayList<Container>();
	containerList.add(container1);
	createDefaultContainerIfDoesNotExist("QA Default Container 2", systemUser, qaSharedHost);
	createDefaultContainerIfDoesNotExist("QA Default Container 3", systemUser, qaSharedHost);
	createDefaultContainerIfDoesNotExist("QA Default Container 4", systemUser, qaSharedHost);
	createDefaultContainerIfDoesNotExist("QA Default Container 5", systemUser, qaSharedHost);
	createDefaultContainerIfDoesNotExist("QA Default Container 6", systemUser, qaSharedHost);
	createDefaultContainerIfDoesNotExist("QA Default Container 7", systemUser, qaSharedHost);
	createDefaultContainerIfDoesNotExist("QA Default Container 8", systemUser, qaSharedHost);
	createDefaultContainerIfDoesNotExist("QA Default Container 9", systemUser, qaSharedHost);
	createDefaultContainerIfDoesNotExist("QA Default Container 10", systemUser, qaSharedHost);
	
	createTemplateIfDoesNotExist("QA Blank Template", "QA Blank Template Friendly Name", qaSharedHost, systemUser, containerList);
	out.flush();
%>

<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Reuters Category Creation</b><br/>
<%
	Category topicsParent = createCategoryIfDoesNotExist(null, "QA Reuters Topics", "QAReutersTopics", "qareuterstopics", "qareuterstopics", systemUser);
	createSubCategoriesFromFile(topicsParent, "/Users/brent/dotcms/testingautomation/Reuters21578/all-topics-strings.lc.txt", systemUser);

	Category placesParent = createCategoryIfDoesNotExist(null, "QA Reuters Places", "QAReutersPlaces", "qareutersplaces", "qareuterplaces", systemUser);
	createSubCategoriesFromFile(placesParent, "/Users/brent/dotcms/testingautomation/Reuters21578/all-places-strings.lc.txt", systemUser);

	Category peopleParent = createCategoryIfDoesNotExist(null, "QA Reuters People", "QAReutersPeople", "qareuterspeople", "qareuterspeople", systemUser);
	createSubCategoriesFromFile(peopleParent, "/Users/brent/dotcms/testingautomation/Reuters21578/all-people-strings.lc.txt", systemUser);

	Category orgsParent = createCategoryIfDoesNotExist(null, "QA Reuters Orgs", "QAReutersOrgs", "qareutersorgs", "qareutersorgs", systemUser);
	createSubCategoriesFromFile(orgsParent, "/Users/brent/dotcms/testingautomation/Reuters21578/all-orgs-strings.lc.txt", systemUser);

	Category exchangesParent = createCategoryIfDoesNotExist(null, "QA Reuters Exchanges", "QAReutersExchanges", "qareutersexchange", "qareutersexchanges", systemUser);
	createSubCategoriesFromFile(exchangesParent, "/Users/brent/dotcms/testingautomation/Reuters21578/all-exchanges-strings.lc.txt", systemUser);

	out.flush();
%>
<%--
<br/><b>&nbsp;&nbsp;&nbsp;&nbsp;Load Reuters News Articles</b><br/>
<%
	try {
		SAXParserFactory factory = SAXParserFactory.newInstance();
		SAXParser saxParser = factory.newSAXParser();
		
		DefaultHandler handler = new DefaultHandler() {
			ContentletAPI conAPI = APILocator.getContentletAPI();
			User systemUser = APILocator.getUserAPI().getSystemUser();
			User adminUser = null;
			Structure struct = StructureFactory.getStructureByVelocityVarName("ReuterNews");
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
				System.out.println("JBG69 - struct = " + struct);

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
					System.out.println("JBG69 - cat.getCategoryName() = " + cat.getCategoryName());
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
				System.out.println("JBG69 - topicsCategory = " + topicsCategory);
				System.out.println("JBG69 - placesCategory = " + placesCategory);
				System.out.println("JBG69 - peopleCategory = " + peopleCategory);
				System.out.println("JBG69 - orgsCategory = " + orgsCategory);
				System.out.println("JBG69 - exchangesCategory = " + exchangesCategory);
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
					System.out.println("JBG69 - title = " + con.getTitle());
					
					String urlTitle = title.toLowerCase();
					urlTitle = urlTitle.replaceAll("^\\s+|\\s+$", "");
					urlTitle = urlTitle.replaceAll("[^a-zA-Z 0-9]", " ");
					urlTitle = urlTitle.replaceAll("\\s", "-");
					urlTitle = urlTitle.replaceAll("--", "-");
				    while(urlTitle.lastIndexOf("-") == urlTitle.length() -1 ){
				      urlTitle=urlTitle.substring(0,urlTitle.length() -1);
				    }
					System.out.println("JBG69 - urlTitle = " + urlTitle);
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
						System.out.println("******** JBG69 - ERROR - title = " + title + " ********");
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
					System.out.println("******** JBG69 - ERROR - title = " + title + " ********");
					e.printStackTrace();
				}
			}
		};

		saxParser.parse("/Users/brent/dotcms/testingautomation/Reuters21578/reuters21578.xml", handler);
//		saxParser.parse("/Users/brent/dotcms/testingautomation/Reuters21578/reuters1.xml", handler);

//		System.out.println("articleCount=" + new Integer(articleCount));

	} catch (Exception e) {
		e.printStackTrace();
		out.println("ERROR - " + e.getLocalizedMessage());
		out.flush();
	}

	out.flush();
%>
--%>
<b><br/>Finished QA data creation</b>

<%!
public void createSubCategoriesFromFile(Category parent, String filename, User user) {
	BufferedReader br = null;
	String line = null;
	try{
		br = new BufferedReader(new FileReader(filename));
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
			catch(IOException e){
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
			hostAPI.save(host, user, respectFrontendRoles);
		}	
	}
	catch(Exception e) {
		retValue = e;
	}
	return retValue;
}

public Container createDefaultContainerIfDoesNotExist(String title, User user, Host host) throws DotDataException, DotSecurityException, WebAssetException {
	Container retValue = null;
	List<Container> containerList = APILocator.getContainerAPI().findContainersUnder(host);
	for(Container cont : containerList) {
		if(cont.getTitle().equals(title) && cont.isArchived() == false) {
			retValue = cont;
			break;
		}
	}
	
	if(retValue == null) {
		retValue = new Container();
		retValue.setTitle(title);
		retValue.setFriendlyName("Displays page content");
		retValue.setMaxContentlets(25);
		retValue.setStructureInode(StructureFactory.getDefaultStructure().getInode());
		retValue.setCode("#dotedit($CONTENT_INODE, $body)\r\n");
		retValue.setNotes("This container display the body field of the content type Page Content.");
		WebAssetFactory.createAsset(retValue, user.getUserId(), host);
		PublishFactory.publishAsset(retValue, user, false);
	}
	return retValue;
}

public Template createTemplateIfDoesNotExist(String title, String description, Host host, User user, List<Container> containerList) throws DotDataException, DotHibernateException, DotSecurityException, WebAssetException {
	Template retValue = null;
	TemplateAPI templateAPI = APILocator.getTemplateAPI();
	List<Template> templateList = templateAPI.findTemplatesAssignedTo(host);
	for(Template temp : templateList) {
		if(temp.getTitle().equals(title) && temp.isArchived() == false) {
			retValue = temp;
			break;
		}
	}
	
	if(retValue == null) {
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
%>