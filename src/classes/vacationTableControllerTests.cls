@IsTest
public class vacationTableControllerTests {
	@IsTest
	static void test_countRequestTypes(){
		Integer entries = 0;
		List<String> expectedTypes = new List<String>{'Vacation', 'Sick', 'Unpaid'};

		Schema.DescribeFieldResult result = Vacation_Request__c.RequestType__c.getDescribe();
		List<Schema.PicklistEntry> typeEntries = result.getPicklistValues();

		for(Schema.PicklistEntry entry : typeEntries){
			System.assertEquals(entry.getValue(), expectedTypes[entries]);
			entries++;
		}
		System.assertEquals(entries, 3, 'Expected number of entries is 3, got '+entries);
	}

	@IsTest
	static void test_insertNewRequest(){
		Vacation_Request__c newRequest = new Vacation_Request__c(StartDate__c = Date.today(),
				EndDate__c = Date.today().addDays(1), RequestType__c = 'Vacation',
				Status__c = 'New');
		insert newRequest;
		List<Vacation_Request__c> values =[select id from Vacation_Request__c];
		System.assertEquals(values.size(), 1);
	}
}