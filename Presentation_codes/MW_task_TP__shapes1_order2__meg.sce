# MW task with thought probes by Jaana Simola


# --------------- Port codes  -------------
#  1 - fix
#  2 - rest (1 min)
#  10 - switch
#  11 - stay
#  12 - Non-target EASY
#  13 - Target EASY
#  22 - Non-target DIFFICULT
#  23 - Target DIFFICULT
#  31 - Thought Probe - Focused EASY
#  32 - Q2_people EASY
#  33 - Q3_emotion EASY 
#  34 - Q4_past EASY
#  35 - Q5_myself EASY
#  36 - Q6_future EASY
#  37 - Q7_words EASY
#  38 - Q8_images EASY
#  39 - Q9_vague EASY
#  40 - Q10_intrusive EASY 
#  41 - Thought Probe - Focused DIFFICULT
#  42 - Q2_people DIFFICULT
#  43 - Q3_emotion DIFFICULT 
#  44 - Q4_past DIFFICULT
#  45 - Q5_myself DIFFICULT
#  46 - Q6_future DIFFICULT
#  47 - Q7_words DIFFICULT
#  48 - Q8_images DIFFICULT
#  49 - Q9_vague DIFFICULT
#  50 - Q10_intrusive DIFFICULT 
# --------------------------------------------------


scenario = "MW_task_TP_1_meg__191031";
scenario_type = trials;

active_buttons = 9;
button_codes = 1, 2, 3, 4, 5, 6, 7, 8, 9;   
target_button_codes = 1, 2, 3, 4, 5, 6, 7, 8, 9;
#active_buttons = 3;
#button_codes = 1, 2, 3;   
#target_button_codes = 1, 2, 3;
write_codes = true;
pulse_width = 5 ; 
#screen_width = 1024; #800
#screen_height = 768; #600
#screen_bit_depth = 32; 

default_trial_type = first_response;      
default_font_size = 24;
default_font = "Arial black";       
response_logging = log_active ;  

response_matching = simple_matching; 

default_background_color = 88, 88, 88; 
default_text_color = 0, 0, 0; 

# -----------------------------
# define variables
# -----------------------------
$nonTarg_dur  = 500; 	# non-target stimulus duration: Kohishi et al. (2017) had 1.3 - 1.7 s (mean 1.5 s)
$Targ_dur = 4000; 		# target stim duration: Kohishi et al. (2017) had 2.1 - 2.5 s (mean 2.3 s), Konishi et al. (2015) had 4 s with target presentation ending in the response
#$fix_dur   = 250; 		# fix cross duration, now jittered between 1.8 - 2.2 s in PCL
$switch_dur = 4000;		# switch task
$stay_dur = 1000;			# stay in the same task
$tp_dur = 10000;			# 5 s to respond to TP-questions - CHANGE to 10000
$rest_dur = 60000; 		# resting state duration (1 min) -# CHANGE to 600000 

########################### SDL ##################################
begin;

text { caption = "+"; font_color = 0,0,0;  } fixcros;
text { caption = "SWITCH"; font_color = 0,0,0; } switch;
text { caption = "STAY"; font_color = 0,0,0; } stay;
text { caption = " "; } tp1;
text { caption = " "; font_size = 18;} emptyQuestion;

picture { text fixcros; x = 0; y = 0; } fix_pic;
picture { text switch; x = 0; y = 0; } switch_pic;
picture { text stay; x = 0; y = 0; } stay_pic;
picture {} stimPic;



# -----------------------------
# bitmap definitions
# -----------------------------
array { 
	LOOP $i 8; 
		$k = '$i + 1';
		bitmap { filename = ""; preload = false; alpha = -1; };		
	ENDLOOP;
} nonTarg_png;

bitmap { filename = ""; preload = false; alpha = -1; } Targ_png;


# -----------------------------
# trial definitions
# -----------------------------
trial {
	trial_duration = forever ;
	trial_type = correct_response;	
	picture {
		text { caption = 
		"The task is the same as you just did before. \n
		Occasionally a series of questions will be asked about the content of your thought. \n
		For example, you will be asked:  \n
		'Were you focused on the task or were you thinking about something else?' \n\n
		Being completely ON task means that you were fully focused\n and only thinking about the computer task. \n
		Being completely OFF task means that you were thinking about something unrelated,\nlike a past vacation or what you'll have for dinner. \n
		
		Use the fingers of your LEFT hand to respond to these questions.\n
		Not at all (1) - Completely (4)\n
				
		Try to focus on the center of the display throughout the experiment.\n";
		#font_size = 20; 
		text_align = align_center; };
		x = 0; y = 0;
	};
	
	time = 0;
	target_button = 9; # enter
} instruction;   

trial {
	trial_duration = forever ;
	trial_type = correct_response;	
	picture {
		text { caption = 
		"Before the task, relax for 1 min and focus you gaze in the center";		
		#font_size = 10; 
		text_align = align_center; };
		x = 0; y = 0;
	};
	
	time = 0;
	target_button = 9; # enter
} restInstruction;  

trial {   
	start_delay = 50;
	stimulus_event {
      picture {   
         text { caption = "+"; } text6; # font_color = 192,192,192;
			x = 0; y = 0;
      } pic4;
	code = "rest";
	port_code = 2;
	duration = $rest_dur; 
   } event5;       
} resttrial;  

trial {   
      picture  {  
         text { caption = "3"; } text8; 
			x = 0; y = 0;          
		} pic8;
      time = 0; duration = 1000;

      picture {
        text { caption = "2"; } text7;
			x = 0; y = 0; 
		} pic5;
		time = 1000; duration = 1000;
		
		picture { 
			text { caption = "1"; } text9;
			x = 0; y = 0; 
		} pic6;
		time = 2000; duration = 1000;
} countdown;  



trial {
	picture fix_pic ; 
	time = 0 ; 														
	#duration = $fix_dur;  # This is now jittered in PCL
	code = "fix";
	port_code = 1;
} fixTrial; 

trial {
	start_delay = 50;	
	picture switch_pic ; 															
	duration = $switch_dur;  
	code = "switch";
	port_code = 10;
} switchTrial; 

trial {
	start_delay = 50;	
	picture stay_pic ; 													
	duration = $stay_dur;  
	code = "stay";
	port_code = 11;
} stayTrial; 


trial { 	
	stimulus_event {
		picture stimPic ;
		duration = $nonTarg_dur ;
	}nonTargetEvent;
} nonTargetTrial;

trial { 	
	trial_type = first_response; 	# Konishi et al. (2015), target lasted maximum of 4 seconds and a response immediately ended the target presentation
	trial_duration = $Targ_dur; 	# The duration of the trial in the absence of button presses 
	all_responses = false;			# Only responses made while a stimulus is response active can end a trial
	
	stimulus_event {
		picture stimPic ;
		stimulus_time_in = 0;
		stimulus_time_out = $Targ_dur;
	}targetEvent; 	
} targetTrial;


trial {
	trial_duration = $tp_dur;
	trial_type = first_response; # Does it stop to the response??
	stimulus_event {
		picture { text emptyQuestion; x = 0; y = 0; };
	} tpEvent;		
} tpTrial;

trial { 
	trial_duration = 2000 ;
	picture {
		text { caption = 
		"Thank you!";
		font_color = 0,0,0;
		text_align = align_center; };
		x = 0; y = 0;
	};
	time = 0;	
 } ThankYou;

######################### END SDL ################################


########################### PCL ##################################
begin_pcl;


output_file ofile = new output_file; # for debugging
ofile.open( "mw_task_TP.txt"); 
ofile.print( "Trial\tSet\tCond\tfName\tfDur\n" );

###### Variables ######

int last = 1;
int nonTarg_NUM = 0;
int fixIdx = 1;
int fixIdx2 = 1;
int setIdx = 1;
int setIdx2 = 1;
int numblocks = 3;	# How many blocks? In total, 3 (easy) + 3 (difficult) = 6 Blocks

# How many times nonTargets are presented (Konishi et al. 2-6) 
array <int> set_length_easy[33] = { 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4  };
array <int> set_length_diff[33] = { 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4  };
 
# How many times the same task is presented (Konishi et al. 2-5)? 
array <int> num_trials_easy[3] = { 10, 11, 12 };
array <int> num_trials_diff[3] = { 10, 11, 12 };
array <int> left_or_right[10] = { 1, 2, 1, 2, 1, 2, 1, 2, 1, 2 };		# Correct answer: 1 = LEFT, 2 = RIGHT

# Randomize
set_length_easy.shuffle(); 
set_length_diff.shuffle();
num_trials_easy.shuffle();
num_trials_diff.shuffle();

# Stimuli Easy condition
array <string> nonTarg_pic_easy[6] = { "Ecircle_square_1.png",   "Ecircle_triangle_1.png",   "Esquare_circle_1.png",   "Esquare_triangle_1.png", "Etriangle_circle_1.png", "Etriangle_square_1.png"	};
array <int> nonTarg_pic_easy_Num[6] = { 1, 2, 3, 4, 5, 6 };
array <string> Targ_pic_easy_LEFT[6] = { "circle_squareCIRCLE_1.png",  "circle_triangleCIRCLE_1.png",  "square_circleSQUARE_1.png", "square_triangleSQUARE_1.png", "triangle_circleTRIANGLE_1.png", "triangle_squareTRIANGLE_1.png"	};
array <string> Targ_pic_easy_RIGHT[6] = { "circle_squareSQUARE_1.png",  "circle_triangleTRIANGLE_1.png", "square_circleCIRCLE_1.png", "square_triangleTRIANGLE_1.png",  "triangle_circleCIRCLE_1.png", "triangle_squareSQUARE_1.png" };

# Stimuli Difficult condition
array <string> nonTarg_pic_diff[12] =  { "Hsquare_circle_1.png", "Hsquare_triangle_1.png", "Hcircle_triangle_1.png", "Hcircle_square_1.png" , "Htriangle_circle_1.png", "Htriangle_square_1.png", "Hcircle_square_1.png", "Htriangle_square_1.png", "Hsquare_circle_1.png",  "Htriangle_circle_1.png" , "Hcircle_triangle_1.png", "Hsquare_triangle_1.png"  };
array <int> nonTarg_pic_diff_Num[12] = { 1, 2, 3, 4, 5, 6, 4, 6, 1, 5, 3, 2 };

array <string> Targ_pic_1[2] = { "targetSQUARE_1.png", "targetCIRCLE_1.png"};
array <string> Targ_pic_2[2] = { "targetSQUARE_1.png", "targetTRIANGLE_1.png"};
array <string> Targ_pic_3[2] = { "targetCIRCLE_1.png", "targetTRIANGLE_1.png"};
array <string> Targ_pic_4[2] = { "targetCIRCLE_1.png", "targetSQUARE_1.png"};
array <string> Targ_pic_5[2] = { "targetTRIANGLE_1.png", "targetCIRCLE_1.png"};
array <string> Targ_pic_6[2] = { "targetTRIANGLE_1.png", "targetSQUARE_1.png"};


array <int> Targ_12[2] = {1, 2}; 
array <string> Targ_code_diff[2] = {"Targ_diff_LEFT", "Targ_diff_RIGHT"};
array <int> Targ_button_diff[12] = { 1, 2 };


array <int> rand_lista[6]; 
loop int i = 1; until i > 6 begin
	rand_lista[i] = i;
	i = i + 1;
end;

array <int> rand_lista2[12];
loop int i = 1; until i > 12 begin
	rand_lista2[i] = i;
	i = i + 1;
end;

# Create to lists for fix cross presentation to match ISIs
array <int> ii[400];
loop int i = 1; until i > 400 begin
	ii[i] = i;
	ii[i] = ii[i] + 1800; # 1800-2200 ms, same as in Konishi et al.(2017) except steps that were 0.05 s
	i = i + 1;
end;

ii.resize( 162 );
array <int> fix_dur_jitter_lista[162] = ii;
array <int> fix_dur_jitter_lista2[162] = ii;
fix_dur_jitter_lista.shuffle();
fix_dur_jitter_lista2.shuffle();



#################################
#### THOUGHT PROBE QUESTIONS ####
#################################

int proportion_TP = 7; 	# 20% change of a thought probe being presented in place of a target
int proportion_noTP = 28;

array <int> TP_list[ proportion_TP ]; # Proportion of thought probes 25 %
array <int> noTP_list[ proportion_noTP ]; 

loop int i = 1; until i > proportion_TP begin
	TP_list[i] = 1;
	i = i + 1;
end;

loop int i = 1; until i > proportion_noTP begin
	noTP_list[i] = 0;
	i = i + 1;
end;

TP_list.append( noTP_list );
array <int> TP_list2[35] = TP_list;
TP_list.shuffle (); 
TP_list2.shuffle ();
int TPIdx_easy = 1;
int TPIdx_diff = 1;

array <int> quest_lista[9]; 
loop int i = 1; until i > 9 begin
	quest_lista[i] = i;
	i = i + 1;
end;

string Question_1 = "My thoughts were focused on the task I was performing:\n Not at all (1) / Completely (4)";

array <string> Questions[9] = { 
	"My thoughts involved other people:\n Not at all (1) - Completely (4)",
	"The content of my thought was:\n Negative (1) - Positive (4)",
	"My thoughts involved past events:\n Not at all (1) - Completely (4)",
	"My thoughts involved myself:\n Not at all (1) - Completely (4)",
	"My thoughts involved future events:\n Not at all (1) - Completely (4)",
	"My thoughts were in the form of words:\n Not at all (1) - Completely (4)",
	"My thoughts were in the form of images:\n Not at all (1) - Completely (4)",
	"My thoughts were vague and non-specific:\n Not at all (1) - Completely (4)",
	"My thoughts were intrusive:\n Not at all (1) - Completely (4)"
}; 

array <string> Question_codes_easy[9] = {"Q2_people_EASY", "Q3_emotion_EASY", "Q4_past_EASY", "Q5_myself_EASY", "Q6_future_EASY", "Q7_words_EASY", "Q8_images_EASY", "Q9_vague_EASY", "Q10_intrusive_EASY" };
array <string> Question_codes_diff[9] = {"Q2_people_DIFF", "Q3_emotion_DIFF", "Q4_past_DIFF", "Q5_myself_DIFF", "Q6_future_DIFF", "Q7_words_DIFF", "Q8_images_DIFF", "Q9_vague_DIFF", "Q10_intrusive_DIFF" };
array <int> Question_port_codes_easy[9] = { 32, 33, 34, 35, 36, 37, 38, 39, 40 };
array <int> Question_port_codes_diff[9] = { 42, 43, 44, 45, 46, 47, 48, 49, 50 };



#########################
###### SHOW TRIALS ######
#########################

# intialize eye tracker
#eye_tracker tracker = new eye_tracker( "PresLink" ); # initialize PresLink.
#tracker.start_tracking() ;#connect to Eyelink tracker.

#open edf file on the tracker.
string edf_name = "trackl1.edf"; #8 letters maxixum without ".edf"
#tracker.set_parameter("open_edf_file",edf_name);
#tracker.set_recording(true); #start recording.
#tracker.send_message("START");#mark the time we presented the stimulus

instruction.present();
restInstruction.present();
resttrial.present ();
countdown.present ();

loop int k = 1; until k > numblocks begin
#loop int k = 1; until k > 1 begin	


	# ------------ DIFFICULT CONDITION -----------------
	
	if k > 1 then # Do not present "SWITCH" on the first block		 
		string msg = "SWITCH";		
		#tracker.send_message(msg);
		switchTrial.present();
	end;

	last = 1;
	
	loop int tr = 1; until tr > num_trials_diff[k] begin
		
		loop int st = 1; until st > set_length_diff[setIdx2] begin 
		
			rand_lista2.shuffle();
			
			if nonTarg_pic_diff_Num[rand_lista2[1]] == nonTarg_pic_diff_Num[last] then	# Don't show the same non-target stimulus in a row 
				rand_lista2.shuffle();
			end;
		
			# SHOW FIX
			# ---------
			fixTrial.set_duration( fix_dur_jitter_lista2[fixIdx2] ); 			
			string msg = "FIXCROSS";
			#tracker.send_message(msg);
			fixTrial.present();
			fixIdx2 = fixIdx2 + 1;
			
			
			# SHOW NON-TARGET STIMULI - DIFFICULT CONDITION
			# ---------------------------------------------
			nonTarg_png[st].set_filename( nonTarg_pic_diff[ rand_lista2[1]] ); 
			nonTarg_png[st].load();
			stimPic.add_part( nonTarg_png[st], 0,0 );
			nonTargetEvent.set_event_code( "NT_diff" ); 	
			nonTargetEvent.set_port_code( 22 ); 
			#nonTargetTrial.set_duration( 2500 ); 		
			
			# string msg = "NONTARGET";
			msg = "NT_DIFF_";
			msg.append(string(st));
			#tracker.send_message(msg);

			nonTargetTrial.present();	
			stimPic.remove_part( 1 ); 
				
			ofile.print( setIdx2  );		
			ofile.print( "\t" );
			ofile.print( st );
			ofile.print( "\t" );
			ofile.print( 2 );			
			ofile.print( "\t" );
			ofile.print( nonTarg_pic_diff[ rand_lista2[1]] ); 								
			ofile.print( "\n" );
		
			last = rand_lista2[1];
			nonTarg_NUM = nonTarg_pic_diff_Num[rand_lista2[1]];
		
			st = st + 1;
	
		end;

		setIdx2 = setIdx2 + 1;
		
		# DO NOT SHOW THOUGHT PROBES  
		# ------------------------------------
		if TP_list2[TPIdx_diff] == 0 then 
			TPIdx_diff = TPIdx_diff + 1;

			# SHOW TARGET STIMULI - DIFFICULT CONDITION
			# ---------------------------------------------
		
			# SHOW FIX
			# ---------
			fixTrial.set_duration( fix_dur_jitter_lista2[fixIdx2] ); 
			string msg = "FIXCROSS";
			#tracker.send_message(msg);
			fixTrial.present();
			fixIdx2 = fixIdx2 + 1;
		
		
			Targ_12.shuffle();	
			
			if nonTarg_NUM == 1 then		
				
				Targ_png.set_filename( Targ_pic_1[Targ_12[1]] ); 
				Targ_png.load();
				stimPic.add_part( Targ_png, 0,0 );
				
				targetEvent.set_event_code( Targ_code_diff[Targ_12[1]] ); 
				targetEvent.set_target_button( Targ_button_diff[Targ_12[1]] ); 
				targetEvent.set_port_code( 23 ); 
				
				msg = "TARG_DIFF_";
				msg.append(string(tr));
				#tracker.send_message(msg);

				targetTrial.present();	
				stimPic.remove_part( 1 ); 
			
				ofile.print( 22 );		
				ofile.print( "\t" );
				ofile.print( 22 );
				ofile.print( "\t" );
				#ofile.print( cond[k] );
				ofile.print( TP_list2[TPIdx_diff] );
				ofile.print( "\t" );
				ofile.print( Targ_pic_1[Targ_12[1]] ); 									
				ofile.print( "\n" );
				
			elseif nonTarg_NUM == 2 then
			
				Targ_png.set_filename( Targ_pic_2[Targ_12[1]] ); 
				Targ_png.load();
				stimPic.add_part( Targ_png, 0,0 );
				
				targetEvent.set_event_code( Targ_code_diff[Targ_12[1]] ); 
				targetEvent.set_target_button( Targ_button_diff[Targ_12[1]] ); 
				targetEvent.set_port_code( 23 ); 
								
				msg = "TARG_DIFF";
				msg.append(string(tr));
				#tracker.send_message(msg);

				targetTrial.present();	
				stimPic.remove_part( 1 ); 
			
				ofile.print( 22 );		
				ofile.print( "\t" );
				ofile.print( 22 );
				ofile.print( "\t" );
				#ofile.print( cond[k] );
				ofile.print( TP_list2[TPIdx_diff] );
				ofile.print( "\t" );
				ofile.print( Targ_pic_2[Targ_12[1]] ); 									
				ofile.print( "\n" );
				
			elseif nonTarg_NUM == 3 then
			
				Targ_png.set_filename( Targ_pic_3[Targ_12[1]] ); 
				Targ_png.load();
				stimPic.add_part( Targ_png, 0,0 );
				
				targetEvent.set_event_code( Targ_code_diff[Targ_12[1]] ); 
				targetEvent.set_target_button( Targ_button_diff[Targ_12[1]] ); 
				targetEvent.set_port_code( 23 ); 
								

				msg = "TARG_DIFF_";
				msg.append(string(tr));
				#tracker.send_message(msg);

				targetTrial.present();	
				stimPic.remove_part( 1 ); 
			
				ofile.print( 22 );		
				ofile.print( "\t" );
				ofile.print( 22 );
				ofile.print( "\t" );
				#ofile.print( cond[k] );
				ofile.print( TP_list2[TPIdx_diff] );
				ofile.print( "\t" );
				ofile.print( Targ_pic_3[Targ_12[1]] ); 									
				ofile.print( "\n" );

			elseif nonTarg_NUM == 4 then
			
				Targ_png.set_filename( Targ_pic_4[Targ_12[1]] ); 
				Targ_png.load();
				stimPic.add_part( Targ_png, 0,0 );
				
				targetEvent.set_event_code( Targ_code_diff[Targ_12[1]] ); 
				targetEvent.set_target_button( Targ_button_diff[Targ_12[1]] ); 
				targetEvent.set_port_code( 23 ); 
								
				msg = "TARG_DIFF";
				msg.append(string(tr));
				#tracker.send_message(msg);

				targetTrial.present();	
				stimPic.remove_part( 1 ); 
			
				ofile.print( 22 );		
				ofile.print( "\t" );
				ofile.print( 22 );
				ofile.print( "\t" );
				#ofile.print( cond[k] );
				ofile.print( TP_list2[TPIdx_diff] );
				ofile.print( "\t" );
				ofile.print( Targ_pic_4[Targ_12[1]] ); 									
				ofile.print( "\n" );
				
			elseif nonTarg_NUM == 5 then
			
				Targ_png.set_filename( Targ_pic_5[Targ_12[1]] ); 
				Targ_png.load();
				stimPic.add_part( Targ_png, 0,0 );
				
				targetEvent.set_event_code( Targ_code_diff[Targ_12[1]] ); 
				targetEvent.set_target_button( Targ_button_diff[Targ_12[1]] ); 
				targetEvent.set_port_code( 23 ); 
								
				msg = "TARG_DIFF";
				msg.append(string(tr));
				#tracker.send_message(msg);

				targetTrial.present();	
				stimPic.remove_part( 1 ); 
			
				ofile.print( 22 );		
				ofile.print( "\t" );
				ofile.print( 22 );
				ofile.print( "\t" );
				#ofile.print( cond[k] );
				ofile.print( TP_list2[TPIdx_diff] );
				ofile.print( "\t" );
				ofile.print( Targ_pic_5[Targ_12[1]] ); 									
				ofile.print( "\n" );

			elseif nonTarg_NUM == 6 then
			
				Targ_png.set_filename( Targ_pic_6[Targ_12[1]] ); 
				Targ_png.load();
				stimPic.add_part( Targ_png, 0,0 );
				
				targetEvent.set_event_code( Targ_code_diff[Targ_12[1]] ); 
				targetEvent.set_target_button( Targ_button_diff[Targ_12[1]] ); 
				targetEvent.set_port_code( 23 ); 
								
				msg = "TARG_DIFF";
				msg.append(string(tr));
				#tracker.send_message(msg);

				targetTrial.present();	
				stimPic.remove_part( 1 ); 
			
				ofile.print( 22 );		
				ofile.print( "\t" );
				ofile.print( 22 );
				ofile.print( "\t" );
				#ofile.print( cond[k] );
				ofile.print( TP_list2[TPIdx_diff] );
				ofile.print( "\t" );
				ofile.print( Targ_pic_6[Targ_12[1]] ); 									
				ofile.print( "\n" );
				
			end;

		# SHOW THOUGHT PROBES 
		# ----------------------------
		elseif TP_list2[TPIdx_diff] == 1 then 
			
			# The 1 st question is always the same
			emptyQuestion.set_caption( Question_1 );
			emptyQuestion.redraw();
			emptyQuestion.load();
			tpEvent.set_event_code( "Q1_focused_DIFF" );
			tpEvent.set_port_code( 41 );
			tpTrial.present();

			# Other 9 questions presented in random order
			quest_lista.shuffle();

			loop int quest = 1; until quest > 9 begin

				fixTrial.set_duration( 	250 ); 
				fixTrial.present();

				emptyQuestion.set_caption( Questions[quest_lista[quest]] );
				emptyQuestion.redraw();
				emptyQuestion.load();
				
				tpEvent.set_event_code( Question_codes_diff[quest_lista[quest]] );
				tpEvent.set_port_code( Question_port_codes_diff[quest_lista[quest]] );
				tpEvent.set_target_button( 1 ); 
				tpTrial.present();
	
			quest = quest + 1	
			end;

		TPIdx_diff = TPIdx_diff + 1;
		end;

	
	tr = tr + 1;
	
	if tr <= num_trials_diff[k] then
		string msg = "STAY";
		#tracker.send_message(msg);
		stayTrial.present();	
	end;
	end;

	# ----------- EASY CONDITION -------------

	string msg = "SWITCH";
	#tracker.send_message(msg);
	switchTrial.present();
	
	last = 1;
	
	loop int tr = 1; until tr > num_trials_easy[k] begin	
			
		loop int st = 1; until st > set_length_easy[setIdx] begin 
			
			rand_lista.shuffle();
			
			# SHOW FIX
			# ---------
			fixTrial.set_duration( fix_dur_jitter_lista[fixIdx] );			
			msg = "FIXCROSS";
			#tracker.send_message(msg);			
			fixTrial.present();
			fixIdx = fixIdx + 1;
			

			
			# SHOW NON-TARGET STIMULI - EASY CONDITION
			# ----------------------------------------

			if nonTarg_pic_easy_Num[rand_lista[1]] == nonTarg_pic_easy_Num[last] then	# Don't show the same non-target stimulus in a row 
				rand_lista.shuffle();
			end;
			
			nonTarg_png[st].set_filename( nonTarg_pic_easy[ rand_lista[1]] );  
			nonTarg_png[st].load();
			stimPic.add_part( nonTarg_png[st], 0,0 );
			nonTargetEvent.set_event_code( "NT_easy" ); 	
			nonTargetEvent.set_port_code( 12 ); 	
			 
			msg = "NT_EASY_";
			msg.append(string(st));
			#tracker.send_message(msg);
		
			nonTargetTrial.present();	
			stimPic.remove_part( 1 ); # Important! otherwise images overlaid
				
			ofile.print( setIdx );		
			ofile.print( "\t" );
			ofile.print( st );
			ofile.print( "\t" );
			ofile.print( 1 );
			ofile.print( "\t" );
			ofile.print(  nonTarg_pic_easy[ rand_lista[1]] );						
			ofile.print( "\n" );
		
			last = rand_lista[1];
		
			st = st + 1;
		
		end;
		
		setIdx = setIdx + 1;
					
		# SHOW FIX
		# ---------
		fixTrial.set_duration( fix_dur_jitter_lista[fixIdx] ); 	
		msg = "FIXCROSS";
		#tracker.send_message(msg);				
		fixTrial.present();	
		fixIdx = fixIdx + 1;
		
		
		# DO NOT show THOUGHT PROBE questions 
		# ------------------------------------
		if TP_list[TPIdx_easy] == 0 then 
			TPIdx_easy = TPIdx_easy + 1;
				
			# SHOW TARGET STIMULUS - EASY CONDITION
			# -------------------------------------
			left_or_right.shuffle();
			rand_lista.shuffle(); # Show random target stimulus (?)
		
			if left_or_right[1] == 1 then
		
				Targ_png.set_filename( Targ_pic_easy_LEFT[ rand_lista[1]] );  
				Targ_png.load();
				stimPic.add_part( Targ_png, 0,0 );				
				targetEvent.set_event_code( "Targ_easy_LEFT" ); 	
				targetEvent.set_target_button( 1 );
				targetEvent.set_port_code( 13 ); 	

				msg = "TARG_EASY_";
				msg.append(string(tr));
				#tracker.send_message(msg);
 
				targetTrial.present();	
				stimPic.remove_part( 1 ); 
			
				ofile.print( 11 );		
				ofile.print( "\t" );
				ofile.print( 11 );
				ofile.print( "\t" );
				#ofile.print( cond[k] );
				ofile.print( TP_list[TPIdx_easy] );
				ofile.print( "\t" );
				ofile.print(  Targ_pic_easy_LEFT[ rand_lista[1]] );									
				ofile.print( "\n" );
			
			elseif left_or_right[1] == 2 then
			
				Targ_png.set_filename( Targ_pic_easy_RIGHT[ rand_lista[1]] );  
				Targ_png.load();
				stimPic.add_part( Targ_png, 0,0 );
				targetEvent.set_event_code( "Targ_easy_RIGHT" ); 
				targetEvent.set_target_button( 2 ); 
				targetEvent.set_port_code( 13 ); 
				
				msg = "TARG_EASY_";
				msg.append(string(tr));
				#tracker.send_message(msg);

				targetTrial.present();	
				stimPic.remove_part( 1 ); 
			
				ofile.print( 11 );		
				ofile.print( "\t" );
				ofile.print( 11 );
				ofile.print( "\t" );
				#ofile.print( cond[k] );
				ofile.print( TP_list[TPIdx_easy] );
				ofile.print( "\t" );
				ofile.print(  Targ_pic_easy_RIGHT[ rand_lista[1]] );								
				ofile.print( "\n" );
			
			end;
	
		# SHOW THOUGHT PROBES 
		# ----------------------------
		elseif TP_list[TPIdx_easy] == 1 then 
			
			# The 1 st question is always the same
			emptyQuestion.set_caption( Question_1 );
			emptyQuestion.redraw();
			emptyQuestion.load();
			tpEvent.set_event_code( "Q1_focused_EASY" );
			tpEvent.set_port_code( 31 );
			tpTrial.present();

			# Other 9 questions presented in random order
			quest_lista.shuffle();

			loop int quest = 1; until quest > 9 begin

				fixTrial.set_duration( 	250 ); 
				fixTrial.present();

				emptyQuestion.set_caption( Questions[quest_lista[quest]] );
				emptyQuestion.redraw();
				emptyQuestion.load();
				
				tpEvent.set_event_code( Question_codes_easy[quest_lista[quest]] );
				tpEvent.set_port_code( Question_port_codes_easy[quest_lista[quest]] );
				tpEvent.set_target_button( 1 ); 
				tpTrial.present();			
	
				quest = quest + 1	
			end;


		TPIdx_easy = TPIdx_easy + 1;
		end;

	
	tr = tr + 1;
	
	if tr <= num_trials_easy[k] then
		msg = "STAY";
		#tracker.send_message(msg);
		stayTrial.present();	
	end

	end;


k = k + 1;	
	
end;	
	

fixTrial.set_duration( 2000 ); 
string msg = "FIXCROSS";
#tracker.send_message(msg);
fixTrial.present();
		
ThankYou.present();

ofile.close();

#tracker.send_message("END");#mark the time we presented the stimulus
#tracker.set_recording(false); #stop recording.

# ------------------------------------------
#transfer the edf file. Note Presentation places files specified
#without a path in the users home directory.
#in this example track.edf will be placed in your home directory.
#(eg. in xp #C:\documents and settings\<username>
# ------------------------------------------

string edf_fname = logfile_directory + logfile.subject() + "MW.edf";

# Gets the edf-file to the stimulus PC, on defined locations
# ------------------------------------------
#tracker.set_parameter("get_edf_file",edf_fname); 
#tracker.stop_tracking();					