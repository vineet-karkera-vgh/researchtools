#Author: Vineet Karkera
#!/usr/bin/tclsh


#This function will be executed when the button is pushed
proc push_button {} {
	global age occupied gender
	set name [.ent get]
	.txt insert end "$name\($gender\) is $age years old and is "
	if { $occupied == 1 } {
		.txt insert end "occupied."
	} else {
		.txt insert end "unemployed."
	}
}

#Global Variables
set age 10
set occupied 1
set gender "Male"
#GUI building
frame .frm_name
label .lab -text "Name:"
entry .ent
#Age
scale .scl -label "Age :" -orient h -digit 1 -from 10 -to 50 \
	-variable age -tickinterval 10
checkbutton .chk -text "Occupied" -variable occupied
#Gender
frame .gender
label .lbl_gender -text "Sex "
radiobutton .gender.rdb_m -text "Male"   -variable gender -value "Male"
radiobutton .gender.rdb_f -text "Female" -variable gender -value "Female"
.gender.rdb_m select

button .but -text "Push Me" -command "push_button"

#Text Area
frame .textarea
text .txt -yscrollcommand ".srl_y set" -xscrollcommand ".srl_x set" \
	-width 40 -height 10
scrollbar .srl_y -command ".txt yview" -orient v
scrollbar .srl_x -command ".txt xview" -orient h

#Geometry Management
grid .frm_name -in . -row 1 -column 1 -columnspan 2
grid .lab -in .frm_name -row 1 -column 1
grid .ent -in .frm_name -row 1 -column 2
grid .scl -in . -row 2 -column 1
grid .chk -in . -row 2 -column 2
grid .gender -in . -row 3 -column 2
grid .lbl_gender -in .gender -row 1 -column 1
grid .gender.rdb_m -in .gender -row 1 -column 2
grid .gender.rdb_f -in .gender -row 1 -column 3
grid .but -in . -row 4 -column 1 -columnspan 2
grid .txt   -in .textarea -row 1 -column 1
grid .srl_y -in .textarea -row 1 -column 2 -sticky ns
grid .srl_x -in .textarea -row 2 -column 1 -sticky ew
grid .textarea -in . -row 5 -column 1 -columnspan 2