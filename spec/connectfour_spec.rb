require 'spec_helper'


describe 'Connect Four' do 

	describe 'Token' do 

		it 'initializes to white' do 
			expect(Game::Token.new.color).to eq('white')
		end
		
		describe '#to_c' do
			before :each do
				@token = Game::Token.new
			end

			it 'returns a white token' do
				expect(@token.to_c).to eq("\u26aa")
			end
			it 'returns red token' do
				@token.color = 'red'
				expect(@token.to_c).to eq("\u26d4")
			end
			it 'returns black token' do 
				@token.color = 'black'
				expect(@token.to_c).to eq("\u26ab")
			end

		end
	end

	
	describe 'Board' do
		before :each do
			@board = Game::Board.new
		end

		# tests the initialize and construct methods
		it 'initializes an array' do
			expect(@board.plastic).to be_an_instance_of(Array)
		end

		it 'fills the array with arrays' do
			confirm = @board.plastic.all? { |x| x.class == Array }
			expect(confirm).to be(true)
		end

		it 'fills the arrays inside the array with Tokens' do
			confirm = @board.plastic.all? do |x|
				x.all? { |o| o.color == 'white' }
			end
			expect(confirm).to be(true)
		end

	end






	describe 'Game' do

		before :each do 
			@game = Game.new
		end

		it 'initializes a board' do
			expect(Game.new.board).to be_an_instance_of(Game::Board)
		end

		describe '#drop_token' do

			before :each do
				@game = Game.new
			end

			it 'sets a token to red' do
				@game.drop_token('red', 1)
				expect(@game.board.plastic[0][0].color).to eq('red')
			end

			it 'sets a token to black' do
				@game.drop_token('black', 1)
				expect(@game.board.plastic[0][0].color).to eq('black')
			end

			it 'returns indices of dropped token' do
				@game.drop_token('black', 4)
				expect(@game.drop_token('red', 4)).to eq([1,3]) # double check this.
			end

			it 'sets a token to column 1' do
				@game.drop_token('red', 1)
				expect(@game.board.plastic[0][0].color).to eq('red')
			end
						
			it 'sets a token to column 2' do
				@game.drop_token('red', 2)
				expect(@game.board.plastic[0][1].color).to eq('red')
			end
						
			it 'sets a token to column 3' do
				@game.drop_token('red', 3)
				expect(@game.board.plastic[0][2].color).to eq('red')
			end
						
			it 'sets a token to column 4' do
				@game.drop_token('red', 4)
				expect(@game.board.plastic[0][3].color).to eq('red')
			end
			
			it 'sets a token to column 5' do
				@game.drop_token('red', 5)
				expect(@game.board.plastic[0][4].color).to eq('red')
			end
						

			it 'sets a token to column 6' do
				@game.drop_token('red', 6)
				expect(@game.board.plastic[0][5].color).to eq('red')
			end
			
			it 'sets a token to column 7' do
				@game.drop_token('red', 7)
				expect(@game.board.plastic[0][6].color).to eq('red')
			end			

		end

		it 'validates a good response' do
			test = @game.valid?(1) 
			expect(test).to be(true)
		end

		it 'validates a bad response - too many tokens' do
			6.times { @game.drop_token('red', 1) }
			test = @game.valid?(1)
			expect(test).to be(false)
		end

		it 'validates a bad response - column DNE' do 
			test = @game.valid?(10)
			expect(test).to be(false)
		end

		describe '#winner?(drop_site)' do 


			describe '#win_helper' do 


				it 'returns true' do
					array = []
					2.times do |i|
						array << 'red'
					end
					4.times do |i|
						array << 'black'
					end
					expect(Game.new.win_helper(array, 'black')).to be(true)
				end

				it 'returns false' do
					array = []
					3.times do |i|
						array << 'red'
					end
					3.times do |i|
						array << 'black'
					end
					expect(Game.new.win_helper(array, 'black')).to be(false)
				end
			end

					


			before :each do
				@game = Game.new
			end

			it 'returns false if no adjacent tokens' do
				@game.drop_token('red', 1)
				@game.drop_token('black',1)
				@game.drop_token('black',2)
				@game.drop_token('black',2)
				expect(@game.winner?([0,0])).to be(false)
			end

			it 'returns false if no adjacent tokens' do
				@game.drop_token('red', 7)
				@game.drop_token('black',7)
				@game.drop_token('black',6)
				@game.drop_token('black',6)
				expect(@game.winner?([0,6])).to be(false)
			end

			it 'returns true if token connects four - ACROSS' do
				4.times { |i| @game.drop_token('red', i) }
				expect(@game.winner?([1,0])).to be(true)
			end

			it 'returns true if token connects four - DOWN' do
				4.times { @game.drop_token('black', 3) }
				expect(@game.winner?([2,3])).to be(true)
			end


		end


	end


end	






	



