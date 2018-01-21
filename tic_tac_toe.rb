class TicTacToe  # The game logic
	def initialize(player1, player2)
		@player1 = player1
		@player2 = player2
		@game_board = Board.new
		@current_player = @player2
	end

	def play  # Begins play and returns the winner
		while 1
			@current_player = (@current_player == @player1 ? @player2 : @player1)
			player_turn(@current_player)
			return @current_player.name if winner?(@current_player)
			return "tie" if board_full?
		end
	end

	private

	def winner?(player)  #R Determines if the player has won
		if @game_board.get_mark(1) ==  player.mark
			if @game_board.get_mark(1) == @game_board.get_mark(2) && @game_board.get_mark(2) == @game_board.get_mark(3)
				return true
			elsif @game_board.get_mark(1) == @game_board.get_mark(5) && @game_board.get_mark(5) == @game_board.get_mark(9)
				return true
			elsif @game_board.get_mark(1) == @game_board.get_mark(4) && @game_board.get_mark(4) == @game_board.get_mark(7)
				return true
			end
		elsif @game_board.get_mark(2) ==  player.mark && @game_board.get_mark(2) == @game_board.get_mark(5) && @game_board.get_mark(5) == @game_board.get_mark(8)
			return true
		elsif @game_board.get_mark(3) ==  player.mark && @game_board.get_mark(3) == @game_board.get_mark(6) && @game_board.get_mark(6) == @game_board.get_mark(9)
			return true
		elsif @game_board.get_mark(4) ==  player.mark && @game_board.get_mark(4) == @game_board.get_mark(5) && @game_board.get_mark(5) == @game_board.get_mark(6)
			return true
		elsif @game_board.get_mark(7) ==  player.mark
			if @game_board.get_mark(7) == @game_board.get_mark(5) && @game_board.get_mark(5) == @game_board.get_mark(3)
				return true
			elsif @game_board.get_mark(7) == @game_board.get_mark(8) && @game_board.get_mark(8) == @game_board.get_mark(9)
				return true
			end
		else
			return false
		end 
	end

	def board_full?  # Determines if all spaces on the board have been filled
		(1..9).each do |location|
			if @game_board.get_mark(location) == nil
				return false
			end
		end
		return true
	end

	def player_turn(player)  # Executes one player turn
		begin
			puts "\n#{player.name}, please place an #{player.mark}."
			puts "(Code: 1 = UL, 2 = UC, 3 = UR, 4 = CL, 5 = CC, 6 = CR"
			puts "(7 = BL, 8 = BC, 9 = BR):  "
			location = gets.match(/^\d/)[0]
			raise SquareFilledError if @game_board.get_mark(location.to_i) != nil
		rescue SquareFilledError
			puts "\nPlease choose an empty square.\n"
			retry
		rescue
			puts "\nPlease enter a digit from 1 to 9.\n"
			retry
		end
		@game_board.place_mark(location.to_i, player.mark)
		@game_board.print_board
	end

end

class SquareFilledError < RuntimeError
end

class Board  # Manages the creation and manipulation of the game board
	def initialize
		@block = Array.new(9)
	end

	def get_mark(location)
		@block[location-1]
	end

	def place_mark(location, mark)  # Places an X or O on the game board
		@block[location-1] = mark
	end

	def print_board  # Prints the game board
		puts
		(0..8).each do |index|
			if index == 2 || index == 5 || index == 8
				puts @block[index] ? @block[index] : " "
				puts "---------" if index != 8
			else
				print "#{@block[index] ? @block[index] : ' '} | "
			end
		end
		puts
	end
end

Player = Struct.new(:name, :number, :mark)

begin
	puts "Player One, please enter your name: "
	player1 = Player.new(gets.chomp, 1, "X")
	raise ArgumentError if player1.name.empty?
rescue
	puts "You must enter a name to continue."
	retry
end

begin
	puts "Player Two, please enter your name: "
	player2 = Player.new(gets.chomp, 2, "O")
	raise ArgumentError if player2.name.empty? || player1.name == player2.name
rescue
	if player1.name == player2.name
		puts "Your name must be different from Player One."
	else
		puts "You must enter a name to continue."
	end
	retry
end

puts "#{player1.name}, you will be X."
puts "#{player2.name}, you will be O."
puts "\nLet's begin!\n"

game = TicTacToe.new(player1, player2)
result = game.play

if result == "tie"
	puts "\nThe game ended in a tie!\n"
else
	puts "\nThe winner is #{result}!\n"
end