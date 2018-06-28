//
// Variables for the calendar
//
//
import Foundation

// collects current date
let date = Date()
let calend = Calendar.current

let day = calend.component(.day , from: date)
var weekday = calend.component(.weekday, from: date) - 1
var month = calend.component(.month, from: date) - 1
var year = calend.component(.year, from: date)


