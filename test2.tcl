#Author: Vineet Karkera
#!/usr/bin/tclsh

set line [list aa bb cc]
proc setListOfColumns {}
{  
      set ::colNames [split $line ,]
      puts "Number of Columns in $::colNames are [llength $::colNames] " 
};

puts "Value of colNames outside of proc  - {$colNames}-"
puts "Length of colNames outside is - [llength $::colNames] -"
