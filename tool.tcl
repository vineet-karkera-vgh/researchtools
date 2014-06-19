#!/usr/bin/env tclsh
#Author: Vineet Karkera
package require Tk

#default values
#contains column names
set colNames ""
#contains the delimiter, default set to comma
set delimiter ","
#contains default value of sensitive checkboxes
set checkboxValue 0

#default values of metrics
set missesCost 0.0
set informationLoss 0.0

# initialize number of elements
set sensitiveElementDifference 0
set nonSensitiveElementDifference 0
set numberOfSensitiveElements 0
set numberOfNonSensitiveElements 0

# calculates misses cost as defined by Oliveira in his paper, discussed further in the report submitted
proc checkEachElement {col1 coln1} {  
	global sensitiveElementDifference nonSensitiveElementDifference numberOfSensitiveElements numberOfNonSensitiveElements
	#check if the length of both columns are the same
	if {[llength $col1] == [llength $coln1]} {
			foreach elem1 $col1 elem2 $coln1 {
				incr numberOfSensitiveElements
				#compares each element of the two columns
				if {$elem1 != $elem2} {
					incr sensitiveElementDifference
				}
			}
	}
	#do a check if the column is non-sensitive
	#check is the length of both columns are the same
	if {[llength $col1] == [llength $coln1]} {
			foreach elem1 $col1 elem2 $coln1 {
				incr numberOfNonSensitiveElements
				#compares each element of the two columns
				if {$elem1 != $elem2} {
					incr nonSensitiveElementDifference
				}
			}
	}
	puts "nonSensitiveElementDifference =$sensitiveElementDifference sensitiveElementDifference = $sensitiveElementDifference numberOfSensitiveElements=$numberOfSensitiveElements numberOfNonSensitiveElements=$numberOfNonSensitiveElements"
};


# calculates misses cost as defined by Oliveira in his paper, discussed further in the report submitted
proc getMissesCost {} {  
	global missesCost col1 coln1
	set count 0
	foreach a $col1 b $coln1 {
		if { $a == $b } {
			incr count
		} 
	}
	set missesCost [expr (($count * 100.00 )/ [llength $col1])]
};

# calculates information loss as defined by Oliveira in his paper, discussed further in the report submitted
proc getInformationLoss {} {  
	global informationLoss col1 coln1
	set count 0
	foreach a $col1 b $coln1 {
		if { $a != $b } {
			incr count
		} 
	}
	set informationLoss [expr (($count * 100.00 )/ [llength $col1])]
};

proc analyze {} {  
	global col1 coln1 analyzeFrame welcomeFrame missesCost informationLoss
	set analyzeFrame ".analyzeFrame";
	
	#computes misses cost
	getMissesCost;
	
	#computes information loss
	getInformationLoss;
	
	#compares each element of the two lists passed
	checkEachElement $col1 $coln1;
	
	
	if {[winfo exists $analyzeFrame]} { destroy $analyzeFrame };
	frame $analyzeFrame -borderwidth 10 -background orange;
	
	#pack the welcome frame
	pack $welcomeFrame -side top -expand true -fill both 
	
	#widgets in the window
	#widget - list of metrics
	label $analyzeFrame.lbl4 -text "Efficiency -  %" -background orange -compound left 
	label $analyzeFrame.lbl5 -text "Accuracy -  %" -background orange -compound left 
	label $analyzeFrame.lbl6 -text "Privacy - %" -background orange -compound left 
	label $analyzeFrame.lbl7 -text "Misses Cost - [format "%.2f" $missesCost] %" -background orange -compound left 
	label $analyzeFrame.lbl8 -text "Information Loss - [format "%.2f" $informationLoss] %" -background orange -compound left 
	label $analyzeFrame.lbl9 -text "Metric 5 - %" -background orange -compound left 
	label $analyzeFrame.lbl10 -text "Metric 6 -  %" -background orange -compound left
	pack $analyzeFrame.lbl4 $analyzeFrame.lbl5 $analyzeFrame.lbl6 $analyzeFrame.lbl7 $analyzeFrame.lbl8 $analyzeFrame.lbl9 $analyzeFrame.lbl10  -padx 20
	
	puts "Misses cost : $missesCost  $informationLoss"
 
	#destroy previous frame and packs the new frame
	if {[winfo exists .fourthFrame]} { destroy .fourthFrame };
	pack $analyzeFrame -side top -expand true -fill both
	
	#call proc to draw bar chart with calculated values
	createBarChart;
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
	global t colNames numCols

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
	$t.text1 delete 1.0 end
	while { [gets $fileID line] >= 0 } {
		puts stdout [format "line(%d)=%s" $i $line]
		$t.text1 insert end [format "%s\n" $line]
		incr i
		} ;

	close $fileID
} ; 

# proc to open second file
proc openFile2 {} {
	set fn "openFile2"
	global t

	set myFile [tk_getOpenFile]

	puts stdout [format "%s:myFile=<%s>" $fn $myFile]

	set fileID [open $myFile r]
	
	#the data is split into individual columns
	splitIntoColns $myFile;
	
	#populates the textarea with new information
	set i 1
	$t.text2 delete 1.0 end
	while { [gets $fileID line] >= 0 } {
		puts stdout [format "line(%d)=%s" $i $line]
		$t.text2 insert end [format "%s\n" $line]
		incr i
		} ;

	close $fileID
};

#Selecting the columns with sensitive information
proc gotoFourthStep {} {	
	global colNames welcomeFrame fourthFrame
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
		global checkboxValue$i
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
	
	#destroy previous frames and pack new frame
	if {[winfo exists .myArea]} { destroy .myArea };
	if {[winfo exists .browseButtonFrame]} { destroy .browseButtonFrame };
	if {[winfo exists .textAreaFrame]} { destroy .textAreaFrame };
	if {[winfo exists .nextButtonFrame]} { destroy .nextButtonFrame };
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
	label $secondFrame.lbl3 -text "Step 2 : Upload Sanitized File" -background orange -compound left 
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
wm geometry . "700x600+10+10"
wm title . "Privacy Preserving Algorithm Analysis Tool"

#setting up frame stuff
#splitting widgets into several frames in order to display them well
destroy .myArea .welcomeFrame .b .t .n .f
set f [frame .myArea -borderwidth 10 -background orange]
set welcomeFrame [frame .welcomeFrame -borderwidth 10 -background orange]
set b [frame .browseButtonFrame -borderwidth 10 -background orange]
set t [frame .textAreaFrame -borderwidth 10 -background orange]
set n [frame .nextButtonFrame -borderwidth 10 -background orange]

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

#widget - upload first file label
label $f.lbl2 -text "Step 1 : Upload File before Sanitization" -background orange -compound left 
#widget - upload sanitized file label
label $f.lbl3 -text "Step 2 : Upload Sanitized File" -background orange -compound left 
pack $f.lbl2 -padx 50 -side left
pack $f.lbl3  -padx 100 -side left

#widget - Browse button for first file
button $b.browse1 -text "Browse" -background lightgrey -command {openFile1}
#widget - Browse button for second file
button $b.browse2 -text "Browse" -background lightgrey -command {openFile2}

pack $b.browse1 -padx 120 -side left 
pack $b.browse2 -padx 170 -side left 

#widget - textArea
text $t.text1 -bd 2 -bg white -height 15 -width 40
text $t.text2 -bd 2 -bg white -height 15 -width 40
pack $t.text1 -padx 10 -pady 5 -side left
pack $t.text2 -padx 10 -pady 5 -side left

#widget - next step button
button $n.nextStep -text "Next Step ->" -background lightgrey -command {gotoThirdStep} -padx 15
pack $n.nextStep -padx 20 -pady 20 

#pack the entire frame containing labels
pack $f -side top -expand true -fill both 

#pack the entire frame containing browse buttons
pack $b -side top -expand true -fill both 

#pack the entire frame containing textareas
pack $t -side top -expand true -fill both 

#pack the entire frame containing button to go the next screen
pack $n -side top -expand true -fill both 

# lines within first text area box
$t.text1 insert end "Please upload a csv file from the menu\n" tag0
$t.text1 insert end "Or use the Browse button above...." tag1

# lines within the second text area box
$t.text2 insert end "Please upload a csv file from the menu\n" tag0
$t.text2 insert end "Or use the Browse button above.." tag1

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

#barchart - start
proc 3drect {w args} {
    if [string is int -strict [lindex $args 1]] {
        set coords [lrange $args 0 3]
    } else {
        set coords [lindex $args 0]
    }
    foreach {x0 y0 x1 y1} $coords break
    set d [expr {($x1-$x0)/3}]
    set x2 [expr {$x0+$d+1}]
    set x3 [expr {$x1+$d}]
    set y2 [expr {$y0-$d+1}]
    set y3 [expr {$y1-$d-1}]
    set id [eval [list $w create rect] $args]
    set fill [$w itemcget $id -fill]
    set tag [$w gettags $id]
    $w create poly $x0 $y0 $x2 $y2 $x3 $y2 $x1 $y0 -outline black
    $w create poly $x1 $y1 $x3 $y3 $x3 $y2 $x1 $y0 -outline black -tag $tag
}

proc yscale {w x0 y0 y1 min max} {
   set dy   [expr {$y1-$y0}]
   regexp {([1-9]+)} $max -> prefix
   set stepy [expr {1.*$dy/$prefix}]
   set step [expr {$max/$prefix}]
   set y $y0
   set label $max
   while {$label>=$min} {
       $w create text $x0 $y -text $label -anchor w
       set y [expr {$y+$stepy}]
       set label [expr {$label-$step}]
   }
   expr {$dy/double($max)}
}

proc bars {w x0 y0 x1 y1 data} {
    set vals 0 
	set high 100
	set low 0
    foreach bar $data {
        lappend vals [lindex $bar 1]
    }
    puts "hello"
	set f [yscale $w $x0 $y0 $y1 $low $high]
	puts "value of f is $f"
    set x [expr $x0+30]
    set dx [expr ($x1-$x0-$x)/[llength $data]]
    set y3 [expr $y1-20]
    set y4 [expr $y1+10]
    $w create poly $x0 $y4 [expr $x0+30] $y3  $x1 $y3 [expr $x1-20] $y4 -fill gray60
    set dxw [expr $dx*6/10]
    foreach bar $data {
        foreach {txt val col} $bar break
        set y [expr {round($y1-($val*$f))}]
        set y1a $y1
        if {$y>$y1a} {swap y y1a}
        set tag [expr {$val<0? "d": ""}]
        3drect $w $x $y [expr $x+$dxw] $y1a -fill $col -tag $tag
        $w create text [expr {$x+25}] [expr {$y-18}] -text $val
        $w create text [expr {$x+12}] [expr {$y1a+2}] -text $txt -anchor n
        incr x $dx
    }
    $w lower d
}


proc max list {
    set res [lindex $list 0]
    foreach e [lrange $list 1 end] {
        if {$e>$res} {set res $e}
    }
    set res
}
proc min list {
    set res [lindex $list 0]
    foreach e [lrange $list 1 end] {
        if {$e<$res} {set res $e}
    }
    set res
}
proc swap {_a _b} {
    upvar 1 $_a a $_b b
    foreach {a b} [list $b $a] break
}

proc createBarChart {} {
	global missesCost informationLoss
		
	#destroy previous frame and packs the new frame
	if {[winfo exists .fourthFrame]} { destroy .fourthFrame };
	pack [canvas .c -width 240 -height 280  -background orange -highlightthickness 0] -side top -expand true -fill both	
	bars .c 10 20 240 230 "
			{{Misses Cost} [format "%.2f" $missesCost] red}
			{{Information Loss} [format "%.2f" $informationLoss] yellow}
			{{Hiding Failure} 20 blue}
			{Privacy 3 blue}
			{Privacy 45 blue}
			{Privacy 60 blue}
			{Privacy 12 blue}
		"
	.c create text 120 10 -anchor nw -text "Results of Analysis"
}
#barchart - end