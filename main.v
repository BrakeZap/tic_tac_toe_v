module main

import readline
import strconv
import rand

enum CurrentTurn {
	player
	bot
}

struct GameState {
mut:
	board      [][]string
	is_running bool
	which_turn CurrentTurn
}

fn (state GameState) print_board() {
	for i in state.board {
		println(i)
	}
}

fn (state GameState) check_if_taken(row int, col int) bool {
	if state.board[row][col] != ' ' {
		return true
	}
	return false
}

fn (state GameState) check_if_won() bool {
	mut row := 0
	mut col := 0
	for _ in 0 .. 3 {
		if col == 0 {
			// check forward
			if state.board[row][col] != ' ' && state.board[row][col] == state.board[row][col + 1]
				&& state.board[row][col + 1] == state.board[row][col + 2] {
				return true
			}
			// check down
			if state.board[row][col] != ' ' && state.board[row][col] == state.board[row + 1][col]
				&& state.board[row + 1][col] == state.board[row + 2][col] {
				return true
			}

			// check diagonal
			if state.board[row][col] != ' '
				&& state.board[row][col] == state.board[row + 1][col + 1]
				&& state.board[row + 1][col + 1] == state.board[row + 2][col + 2] {
				return true
			}
		}

		if col == 1 {
			// check down
			if state.board[row][col] != ' ' && state.board[row][col] == state.board[row + 1][col]
				&& state.board[row + 1][col] == state.board[row + 2][col] {
				return true
			}
		}

		if col == 2 {
			// check down
			if state.board[row][col] != ' ' && state.board[row][col] == state.board[row + 1][col]
				&& state.board[row + 1][col] == state.board[row + 2][col] {
				return true
			}

			// check diagonal
			if state.board[row][col] != ' '
				&& state.board[row][col] == state.board[row + 1][col - 1]
				&& state.board[row + 1][col - 1] == state.board[row + 2][col - 2] {
				return true
			}
		}
		col += 1
	}
	row = 1
	col = 0
	for _ in 1 .. 3 {
		// check forward
		if state.board[row][col] != ' ' && state.board[row][col] == state.board[row][col + 1]
			&& state.board[row][col + 1] == state.board[row][col + 2] {
			return true
		}

		row += 1
	}
	return false
}

fn input_num_to_row_col(input int) (int, int) {
	mut row := 0
	mut col := 0
	if input < 3 {
		row = 0
		col = input
	} else if input >= 3 && input < 6 {
		row = 1
		col = input - 3
	} else {
		row = 2
		col = input - 6
	}
	return row, col
}

fn (state GameState) check_if_tie() bool {
	for i in 0 .. 3 {
		if ' ' in state.board[i] {
			return false
		}
	}
	return true
}

fn main() {
	mut board := [][]string{len: 3, init: [' ', ' ', ' ']}

	mut game_state := GameState{
		board:      board
		is_running: true
		which_turn: .player
	}
	game_state.print_board()

	for game_state.is_running {
		input := readline.read_line('Enter a number between 0-8 to choose where to put an X!\n')!
		num := strconv.atoi(input) or {
			println('Not a valid number!')
			continue
		}

		if num >= 9 || num < 0 {
			println('Not a valid number!')
			continue
		}
		mut row, mut col := input_num_to_row_col(num)

		if game_state.check_if_taken(row, col) {
			println('That spot is already taken!')
			continue
		}
		game_state.board[row][col] = 'X'
		game_state.print_board()
		if game_state.check_if_won() {
			println('You win!!')
			game_state.is_running = false
			continue
		}

		if game_state.check_if_tie() {
			println("It's a tie!")
			game_state.is_running = false
			continue
		}

		println("It is now the bot's turn...")

		mut bot_choice := rand.intn(9)!

		row, col = input_num_to_row_col(bot_choice)
		for game_state.check_if_taken(row, col) {
			bot_choice = rand.intn(9)!
			row, col = input_num_to_row_col(bot_choice)
		}
		game_state.board[row][col] = 'O'
		game_state.print_board()
		if game_state.check_if_won() {
			println('The bot wins! Very sad!')
			game_state.is_running = false
			continue
		}

		if game_state.check_if_tie() {
			println("It's a tie!")
			game_state.is_running = false
			continue
		}
	}
}
