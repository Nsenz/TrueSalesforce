trigger requestInsert on Vacation_Request__c (before insert) {
	for(Vacation_Request__c request : trigger.new){
		Integer counter = 0;
		Datetime startDate = request.StartDate__c;
		Datetime endDate = request.EndDate__c;
		while (startDate <= endDate) {
			if (startDate.format('E') != 'Sat' && startDate.format('E') != 'Sun') {
				counter++;
			}
			startDate = startDate.addDays(1);
		}
		request.WorkingDays__c = counter;
	}
}