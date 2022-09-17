public class AccountApiGetResponse{
	public cls_attributes attributes;
	public String Id;	
	public String Name;	
	public String Phone;	
	public String Website;	
	class cls_attributes {
		public String type;	
		public String url;	
	}
	public static AccountApiGetResponse parse(String json){
		return (AccountApiGetResponse) System.JSON.deserialize(json, AccountApiGetResponse.class);
	}
}