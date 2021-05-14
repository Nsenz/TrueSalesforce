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
}