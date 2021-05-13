public class vacationRequest {
	private static Integer count = 0;

	private Integer _id;
	private requestTypes _type;
	private Date _startDate;
	private Date _endDate;

	public vacationRequest(requestTypes type, Date startDate, Date endDate){
		this._id = count++;
		this._type = type;
		this._startDate = startDate;
		this._endDate = endDate;
	}
}