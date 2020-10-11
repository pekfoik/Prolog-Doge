:- use_module(library(dom)).
:- use_module(library(random)).

%open_slots/1
%get the currently open slots(Updated by asserta)
open_slots([index11, index12, index13, index21, index22, index23, index31, index32, index33]).

%mark_won/1
%Add the clas win to the given list
mark_won([]):-
	get_by_id(winner, Obj),
	add_class(Obj, show).
mark_won([X|Rest]):-
	get_by_id(X, Obj),
	add_class(Obj, win),
	mark_won(Rest).

%get_class/2
%Get the clas of a given id(x/o/none)
get_class(ID, x):-
	get_by_id(ID, Obj),
	has_class(Obj, x).

get_class(ID, o):-
	get_by_id(ID, Obj),
	has_class(Obj, o).

get_class(ID, none).

%check_winner/0
%Checks if there is a winner and mark the winner
check_winner:-
	check_rows_win;
	check_columns_win;
	check_diagonal_win.

check_rows_win:-
	check_first_row_win;
	check_second_row_win;
	check_third_row_win.

check_columns_win:-
	check_first_column_win;
	check_second_column_win;
	check_third_column_win.

check_diagonal_win:-
	check_first_diag_win;
	check_second_diag_win.

check_first_row_win:-
	get_class(index11, I11),
	get_class(index12, I12),
	get_class(index13, I13),
	I11\==none,
	I11=I12,
	I12=I13,
	mark_won([index11, index12, index13]).
check_second_row_win:-
	get_class(index21, I21),
	get_class(index22, I22),
	get_class(index23, I23),
	I21\==none,
	I21=I22,
	I22=I23,
	mark_won([index21, index22, index23]).
check_third_row_win:-
	get_class(index31, I31),
	get_class(index32, I32),
	get_class(index33, I33),
	I31\==none,
	I31=I32,
	I32=I33,
	mark_won([index31, index32, index33]).

check_first_column_win:-
	get_class(index11,I11),
	get_class(index21,I21),
	get_class(index31,I31),
	I11\==none,
	I11=I21,
	I21=I31,
	mark_won([index11,index21,index31]).
check_second_column_win:-
	get_class(index12,I12),
	get_class(index22,I22),
	get_class(index32,I32),
	I12\==none,
	I12=I22,
	I22=I32,
	mark_won([index12,index22,index32]).
check_third_column_win:-
	get_class(index13,I13),
	get_class(index23,I23),
	get_class(index33,I33),
	I13\==none,
	I13=I23,
	I23=I33,
	mark_won([index13,index23,index33]).

check_first_diag_win:-
	get_class(index11, I11),
	get_class(index22, I22),
	get_class(index33, I33),
	I11\==none,
	I11=I22,
	I22=I33,
	mark_won([index11,index22,index33]).
check_second_diag_win:-
	get_class(index31, I31),
	get_class(index22, I22),
	get_class(index13, I13),
	I13\==none,
	I13=I22,
	I22=I31,
	mark_won([index31,index22,index13]).

%get_first_member/2
%Gets the first open member in the list(without x or o)
get_first_member([],nil).
get_first_member([X|Rest], X):- 
	get_by_id(X, Obj),
	unbind(Obj, click),
	\+ has_class(Obj, x),
	\+ has_class(Obj, o).
get_first_member([X|Rest], Res):-
	get_first_member(Rest,Res).

%draw_circle/2
%Plays the computer turn with changing difficulties
draw_circle(easy, OpenSpots):-
	get_first_member(OpenSpots, ID),
	get_by_id(ID, Obj),
	add_class(Obj, o),
	(
		check_winner
		;
		true
	).

draw_circle(medium, OpenSpots):-
	get_first_member(OpenSpots, ID),
	get_by_id(ID, Obj),
	add_class(Obj, o),
	(
		check_winner
		;
		true
	).

%bind_events/1
%Bind the click events for each element in the list
bind_events([]).
bind_events([X|Rest]):-
	get_by_id(X, Obj),
	bind(Obj, click, Event, (
		unbind(Obj, click),
		add_class(Obj, x),
		(
			check_winner
		;
			draw_circle(easy, [index11, index12, index13, index21, index22, index23, index31, index32, index33])
		)
	)),
	bind_events(Rest).

% init/0
% Initilize the game
init :-
	open_slots(List),
	bind_events(List).