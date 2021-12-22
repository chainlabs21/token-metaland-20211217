
interface ICalendarLibrary {
        /*
         *  Abstract contract for interfacing with the DateTime contract.
         *
         */
	function isLeapYear(uint256 year) external pure returns (bool);
	function getYear(uint timestamp) external pure returns (uint256);
	function getMonth(uint timestamp) external pure returns (uint256);
	function getDay(uint timestamp) external pure returns (uint256);
	function getHour(uint timestamp) external pure returns (uint256);
	function getMinute(uint timestamp) external pure returns (uint256);
	function getSecond(uint timestamp) external pure returns (uint256);
	function getWeekday(uint timestamp) external pure returns (uint256);
	function toTimestamp(uint256 year, uint256 month, uint256 day) external returns (uint timestamp);
	function toTimestamp(uint256 year, uint256 month, uint256 day, uint256 hour) external returns (uint timestamp);
	function toTimestamp(uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute) external returns (uint timestamp);
	function toTimestamp(uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) external returns (uint timestamp);
}
