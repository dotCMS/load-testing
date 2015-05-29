import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;
 
public class ReadReuters21578File {

	static int articleCount = 0;
 
   public static void main(String argv[]) {
 
    try {
 
	SAXParserFactory factory = SAXParserFactory.newInstance();
	SAXParser saxParser = factory.newSAXParser();
 
	DefaultHandler handler = new DefaultHandler() {
 
	boolean inArticle = false;
	boolean inTopics = false;
	String topics = "";
	boolean inPlaces = false;
	String places = "";
	boolean inPeople = false;
	String people = "";
	boolean inOrgs = false;
	String orgs = "";
	boolean inExchanges = false;
	String exchanges = "";
	boolean inTitle = false;
	String title = "";
	boolean inBody = false;
	String body = "";
	boolean inD = false;
 
	public void startElement(String uri, String localName,String qName, 
                Attributes attributes) throws SAXException {
 
		//System.out.println("Start Element :" + qName);
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
 
	public void endElement(String uri, String localName,
		String qName) throws SAXException {
 
		//System.out.println("End Element :" + qName);
		if (qName.equalsIgnoreCase("REUTERS")) {
			articleCount++;
			inArticle = false;
			System.out.println("TOPICS=" + topics);
			topics = "";
			System.out.println("PLACES=" + places);
			places = "";
			System.out.println("ORGS=" + orgs);
			orgs = "";
			System.out.println("PEOPLE=" + people);
			people = "";
			System.out.println("EXCHANGES=" + exchanges);
			exchanges = "";
			System.out.println("TITLE=" + title);
			title = "";
			System.out.println("BODY=" + body);
			body = "";
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

		if (inArticle) {
			//System.out.println("characters: " + chars);
		}

		if(inTitle && lengthTrimmed > 0) {
			title += chars;
		}
		else if(inBody && lengthTrimmed > 0) {
			body += chars;
		}
		else if(inD && lengthTrimmed > 0) {
			if(inTopics) {
				if(topics.length() > 0)
					topics += ",";
				topics += chars;
			}
			else if(inPlaces) {
				if(places.length() > 0)
					places += ",";
				places += chars;
			}
			else if(inPeople) {
				if(people.length() > 0)
					people += ",";
				people += chars;
			}
			else if(inOrgs) {
				if(orgs.length() > 0)
					orgs += ",";
				orgs += chars;
			}
			else if(inExchanges) {
				if(exchanges.length() > 0)
					exchanges += ",";
				exchanges += chars;
			}
		}
	}
 
     };
 
//      saxParser.parse("reuters21578.xml", handler);
      saxParser.parse("reuters1.xml", handler);

       System.out.println("articleCount=" + new Integer(articleCount));
 
     } catch (Exception e) {
       e.printStackTrace();
     }
 
   }
 
}