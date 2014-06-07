#Author: Vineet Karkera
package require Tk

#default values
#contains column names
set colNames ""
#contains the delimiter, default set to comma
set delimiter ","
#contains an array with key value pair of columns that are privacy sensitive
array set sensitiveArray {}
#contains default value of checkboxes
set checkboxValue 0

proc setSensitiveArray {} {  
	# global x colNames 
	# set i 0
	# foreach var $colNames {
	# set temp1 $var$i
	# set temp2 [set $temp1]
	# puts "ahem $temp1 and $temp2"
    # if {[info exists $var${i}]} {
			# puts "$var$i does indeed exist"
		# } else {
			# puts "$var sadly does not exist"
		# }
		# incr i
	# }
	# puts "The value of the column is $x"
	
};

proc getSensitiveArray {} {  
	global sensitiveArray
	foreach {key value} [array get sensitiveArray] {
		puts "Key: $key Value: $value" 
	}
};

proc analyze {} {  
	global analyzeFrame welcomeFrame
	set analyzeFrame ".analyzeFrame";
	
	getSensitiveArray;
	
	
	if {[winfo exists $analyzeFrame]} { destroy $analyzeFrame };
	frame $analyzeFrame -borderwidth 10 -background orange;
	
	#pack the welcome frame
	pack $::welcomeFrame -side top -expand true -fill both 
	
	#widgets in the window
	#widget - list of metrics
	label $analyzeFrame.lbl4 -text "Efficiency  %" -background orange -compound left 
	label $analyzeFrame.lbl5 -text "Accuracy  %" -background orange -compound left 
	label $analyzeFrame.lbl6 -text "Privacy  %" -background orange -compound left 
	label $analyzeFrame.lbl7 -text "Metric 3" -background orange -compound left 
	label $analyzeFrame.lbl8 -text "Metric 4" -background orange -compound left 
	label $analyzeFrame.lbl9 -text "Metric 5" -background orange -compound left 
	label $analyzeFrame.lbl10 -text "Metric 6" -background orange -compound left
	pack $analyzeFrame.lbl4 $analyzeFrame.lbl5 $analyzeFrame.lbl6 $analyzeFrame.lbl7 $analyzeFrame.lbl8 $analyzeFrame.lbl9 $analyzeFrame.lbl10  -padx 20
 
	#destroy previous frame and packs the new frame
	if {[winfo exists .fourthFrame]} { destroy .fourthFrame };
	pack $analyzeFrame -side top -expand true -fill both
};

#proc to get the first line of the file
proc getFirstLineFromFile {filename} {
	set f [open $filename r]
    set line [gets $f]
    close $f
    return $line
};

#proc to get arithmetic sum of elements in a list
proc ladd L {expr [join $L +]+0}

#proc to split the first file data into columns
proc splitIntoColumns {filename} {
	global numCols
	set f [open $filename r]	
	#the first line containing header names is skipped
	set line [gets $f]
	set file_data [read $f]
	close $f
	
	set data [split $file_data "\n"]
    foreach {line} $data {
		set csvdata [split $line ","]
		set i 0
		foreach {element} $csvdata {
			global col$i
			lappend col$i $element
			incr i			
		}
	}
	
	puts "The summation of the first column is [ladd $col0]"
	
	#debugging
	puts "Col : $col0"
	puts "Col : $col1"
	puts "Col : $col2"
	puts "Col : $col3"
	puts "Col : $col4"
	puts "Col : $col5"
	puts "Col : $col6"
	puts "Col : $col7"
};

#proc to split the second file data into columns
proc splitIntoColns {filename} {
	global numCols
	set f [open $filename r]	
	#the first line containing header names is skipped
	set line [gets $f]
	set file_data [read $f]
	close $f
	
	set data [split $file_data "\n"]
    foreach {line} $data {
		set csvdata [split $line ","]
		set i 0
		foreach {element} $csvdata {
			global coln$i
			lappend coln$i $element
			incr i			
		}
	}
	#debugging
	puts "Col : $coln0"
	puts "Col : $coln1"
	puts "Col : $coln2"
	puts "Col : $coln3"
	puts "Col : $coln4"
	puts "Col : $coln5"
	puts "Col : $coln6"
	puts "Col : $coln7"
};
 
#proc to open first file
proc openFile1 {} {
	set fn "openFile1"
	global f colNames numCols

	set myFile [tk_getOpenFile]

	puts stdout [format "%s:myFile=<%s>" $fn $myFile]

	set fileID [open $myFile r]

	#fetch first line from the file - header names
	set firstLine [getFirstLineFromFile $myFile]

	#split first line into column names
	set colNames [split $firstLine ,]
	
	#number of columns in the file
	set numCols [llength  $colNames ]
	puts "Number of columns in $colNames is $numCols" 

	#the data is split into individual columns
	splitIntoColumns $myFile;
	
	#debugging - vineet - to check if global variables work
	global col0 col1 col2 col3 col4 col5 col6 col7 col8
	puts "Col : $col0"
	puts "Col : $col1"
	puts "Col : $col2"
	puts "Col : $col3"
	puts "Col : $col4"
	puts "Col : $col5"
	puts "Col : $col6"
	puts "Col : $col7"
	
	#populates the textarea with new information
	set i 1
	$f.text1 delete 1.0 end
	while { [gets $fileID line] >= 0 } {
		puts stdout [format "line(%d)=%s" $i $line]
		$f.text1 insert end [format "%s\n" $line]
		incr i
		} ;

	close $fileID
} ; 

# proc to open second file
proc openFile2 {} {
	set fn "openFile2"
	global secondFrame

	set myFile [tk_getOpenFile]

	puts stdout [format "%s:myFile=<%s>" $fn $myFile]

	set fileID [open $myFile r]
	
	#the data is split into individual columns
	splitIntoColns $myFile;
	
	#populates the textarea with new information
	set i 1
	$secondFrame.text2 delete 1.0 end
	while { [gets $fileID line] >= 0 } {
		puts stdout [format "line(%d)=%s" $i $line]
		$secondFrame.text2 insert end [format "%s\n" $line]
		incr i
		} ;

	close $fileID
};

#Selecting the columns with sensitive information
proc gotoFourthStep {} {	
	global colNames welcomeFrame fourthFrame sensitiveArray
	set fourthFrame ".fourthFrame";
	if {[winfo exists $fourthFrame]} { destroy $fourthFrame };
	frame $fourthFrame -borderwidth 10 -background orange;
	
	#pack the welcome frame
	pack $::welcomeFrame -side top -expand true -fill both 
	
	#widgets in the window
	#widget - upload file label
	label $fourthFrame.lblColumns -text "Step 4 : Select the columns with Sensitive data" -background orange -compound left 
	pack $fourthFrame.lblColumns  -padx 20
	
	set i 0
	# #widget - checkbox
	global x
	foreach x $colNames {
		#global checkboxValue$i
		#set c [checkbutton $fourthFrame.checkbox$x -text $x -variable checkboxValue$i -anchor nw -background orange -command [setSensitiveArray]];
		#set c [checkbutton $fourthFrame.checkbox($x) -text $x -variable checkboxVal$i -anchor nw -background orange -command [puts [expr $checkboxVal${i}]]];
		set c [checkbutton $fourthFrame.checkbox($x) -text $x -variable checkboxVal$i -anchor nw -background orange];
		#set tempCheckbox checkboxValue${i}
		#set var3 [set $var2]
		#set t1 checkbox${i}
		#set t2 $$t1
		#puts "The value is ${$t1} and ${$t2}"
		incr i
		pack $c -side top -anchor nw -fill x -expand false;
	}
	
	#widget - next step button
	button $fourthFrame.nextStep -text "Final Step - Analyze" -background lightgrey -command {analyze}
	pack $fourthFrame.nextStep -padx 20 -pady 20
	
	#destroy previous frame and pack new frame
	if {[winfo exists .thirdFrame]} { destroy .thirdFrame};
	pack $fourthFrame -side top -expand true -fill both
};

#selecting the delimiter
proc gotoThirdStep {} {
	global thirdFrame welcomeFrame
	set thirdFrame ".thirdFrame";
	if {[winfo exists $thirdFrame]} { destroy $thirdFrame };
	frame $thirdFrame -borderwidth 10 -background orange;
	
	#pack the welcome frame
	pack $::welcomeFrame -side top -expand true -fill both 
	
	#widgets in the window
	#widget - specify delimiter
	label $thirdFrame.lblDelimiter -text "Step 3 : Specify a delimiter" -background orange -compound left 
	pack $thirdFrame.lblDelimiter  -padx 20

	#widget - delimiter entry field
	entry $thirdFrame.entryDelimiter -width 10 -bd 2 -textvariable delimiter
	pack $thirdFrame.entryDelimiter  -padx 20
	
	#widget - next step button
	button $thirdFrame.nextStep -text "Next Step ->" -background lightgrey -command {gotoFourthStep}
	pack $thirdFrame.nextStep -padx 20 -pady 20
	
	#destroy previous frame and pack new frame
	if {[winfo exists .secondFrame]} { destroy .secondFrame };
	pack $thirdFrame -side top -expand true -fill both
}

# Upload the Second File
proc gotoSecondStep {} {
	global secondFrame welcomeFrame
	set secondFrame ".secondFrame";
	if {[winfo exists $secondFrame]} { destroy $secondFrame };
	frame $secondFrame -borderwidth 10 -background orange;
	
	#pack the welcome frame
	pack $::welcomeFrame -side top -expand true -fill both 
	
	#widgets in the window
	#widget - upload file label
	label $secondFrame.lbl3 -text "Step 2 : Upload Output File" -background orange -compound left 
	pack $secondFrame.lbl3  -padx 20

	#widget - Browse button
	button $secondFrame.browse2 -text "Browse" -background lightgrey -command {openFile2}
	pack $secondFrame.browse2  -padx 20

	#widget - textArea
	text $secondFrame.text2 -bd 2 -bg white -height 7
	pack $secondFrame.text2 -padx 20 -pady 5
	
	#widget - next step button
	button $secondFrame.nextStep -text "Next Step ->" -background lightgrey -command {gotoThirdStep}
	pack $secondFrame.nextStep -padx 20 -pady 20
	
	# lines within the text area
	$secondFrame.text2 insert end "Please upload a csv file from the menu\n" tag0
	$secondFrame.text2 insert end "Or use the Browse button above.." tag1
	
	#delete previous frame
	if {[winfo exists .myArea]} { destroy .myArea };
	pack $secondFrame -side top -expand true -fill both
}

#setting up window
wm geometry . "350x600+10+10"
wm title . "Privacy Preserving Algorithm Analysis Tool"

#setting up the frame stuff
destroy .myArea
set f [frame .myArea -borderwidth 10 -background orange]
set welcomeFrame [frame .welcomeFrame -borderwidth 10 -background orange]

#widgets in the window
#widget - name of tool
label $welcomeFrame.border1 -text "----------------------------------------------" -background orange
pack $welcomeFrame.border1 -padx 20 -pady 5
label $welcomeFrame.lbl1 -text "Welcome to the Privacy Preserving Analysis tool" -background orange
label $welcomeFrame.border2 -text "----------------------------------------------" -background orange
pack $welcomeFrame.lbl1 -padx 20 -pady 5
pack $welcomeFrame.border2 -padx 20 -pady 5

#pack the welcome frame
pack $welcomeFrame -side top -expand true -fill both 

#widget - upload file label
label $f.lbl2 -text "Step 1 : Upload Input File" -background orange -compound left 
pack $f.lbl2  -padx 20

#widget - Browse button
button $f.browse1 -text "Browse" -background lightgrey -command {openFile1}
pack $f.browse1  -padx 20

text $f.text1 -bd 2 -bg white -height 7
pack $f.text1 -padx 20 -pady 5

#widget - next step button
button $f.nextStep -text "Next Step ->" -background lightgrey -command {gotoSecondStep}
pack $f.nextStep -padx 20 -pady 20

#pack the entire first frame
pack $f -side top -expand true -fill both 

# lines within the text area
$f.text1 insert end "Please upload a csv file from the menu\n" tag0
$f.text1 insert end "Or use the Browse button above...." tag1

#creates a menubar
menu .menubar
. config -menu .menubar

#creates a pull down menu with a label 
set File [menu .menubar.mFile]
.menubar add cascade -label File  -menu  .menubar.mFile

#creates a new pull down for quit
set Quit [menu .menubar.quit]
.menubar add cascade -label {Quit} -menu  .menubar.quit

#options for the file drop down
$File add command -label {Open File 1 (Sample input file)} -command openFile1
$File add command -label {Open File 2 (Sample output file)} -command openFile2

#options for the second drop down
$Quit add command -label {Yes, I want to leave!} -command exit
$Quit add command -label {No, I'll stay.}
