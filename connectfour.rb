class Game
	attr_reader :board

	# initializes a board object, randomly selects starting player
	def initialize
		@board = Board.new
		@turn = rand(2) # randomizes which color starts first even BLACK odd RED
	end

	# calls the game loop for no good reason, other than to call #play instead of #game_loop to begin
	def play
		game_loop
	end

	# the main game loop, starts game, solicits turns, displays board, checks for winner, exits
	def game_loop
		puts "Welcome to the game of RED versus BLACK in a "
		puts "Connecting Four battle of wits and colored tokens"
		puts ""
		print "#{ @turn %2 == 0 ? "BLACK" : "RED" } will go first!\n\n"
	
		loop do
			display_board

			@turn % 2 == 0 ? player = "black" : player = "red"
			print "#{player.upcase}! Into which column would you like to drop your token?"

			input = 100
			until valid?(input)
				input = gets.chomp.to_i 
			end

			site = drop_token(player, input)

			if winner?(site)
				puts "\n\n"
				display_board
				puts "Congratulations #{player}! You've won!"
				exit
			end

			@turn += 1
		end
	end

	# illustrates the plastic board to show where tokens reside
	def display_board
		puts "\n\n"
		print "|\u2460 |\u2461 |\u2462 |\u2463 |\u2464 |\u2465 |\u2466 |"
		@board.plastic.reverse.each do |row|
			print "\n|"
			row.each {|x| print "#{x.to_c} |"} 			
		end
		puts ""
	end

	# takes the player's color and drops a token into the specified column ### could probably be refactored
	def drop_token(color, column)
		done = false
		drop_point = []
		6.times do |i|
			if !(done) && @board.plastic[i][column-1].color == "white"
				@board.plastic[i][column-1].color = color
				done = true
				drop_point = [i, column-1]
			end
		end
		drop_point
	end

	# checks first if is for 1 < column < 7; second if is to make sure column is not full
	def valid?(column)
		if (column > 7) || (column < 1)
			return false
		end

		the_column_in_question = []		
		6.times { |i| the_column_in_question << @board.plastic[i][column-1].color }

		if the_column_in_question.count("white") == 0
			false
		else
			true
		end
	end

	# builds arrays that represents directions --, |, \, and /, feeds them to the helper for win/not
	def winner?(drop)
		row = drop[0]
		column = drop[1]
		colour = @board.plastic[row][column].color
		
		left_right = []
		(-3..3).each { |x| left_right << @board.plastic[row][column+x].color unless column+x > 6 || column+x < 0 }
		
		up_down 	 = []
		(-3..3).each { |x| up_down << @board.plastic[row+x][column].color unless row+x > 5 || row+x < 0 }

		forward_s	 = []
		(-3..3).each do |x| 
			unless column-x > 6 || column-x < 0 || row-x > 5 || row-x < 0
				forward_s << @board.plastic[row-x][column-x].color
			end
		end

		back_slash = []
		(-3..3).each do |x| 
			unless column-x > 6 || column-x < 0 || row+x > 5 || row+x < 0
				back_slash << @board.plastic[row+x][column-x].color 
			end
		end

		win_helper(left_right, colour) || win_helper(up_down, colour) || win_helper(forward_s, colour) || win_helper(back_slash, colour)

	end

	# accepts array of colors and color in question, returns true if there are 4 'colours' in a row
	def win_helper(chunk, colour)
		counter = 0
		chunk.each do |x|
			x == colour ? counter += 1 : counter = 0
			if counter == 4
				return true
			end
		end
		false
	end

	# object that holds the array of arrays that holds white tokens, that eventually turn red or black
	class Board
		attr_accessor :plastic

		def initialize
			@plastic = constructor
		end

		# outer array is rows, inner array is columns
		def constructor
			array_of_arrays = []
			6.times do |i|
				array_of_arrays[i] = []
				7.times do 
					array_of_arrays[i] << Token.new 
				end
			end
			array_of_arrays
		end

	end

	# objects that sit in the array - when a token is dropped color is turned to red or black from white
	class Token
		attr_accessor :color

		def initialize
			@color = "white"
		end

		# represents the object's color identity with inauthentic connect four tokens
		def to_c
			if color == "white"
				"\u26aa"
			elsif color == "red"
				"\u26d4"
			elsif color == "black"
				"\u26ab"
			end
		end
	end


end

# Game.new.play











