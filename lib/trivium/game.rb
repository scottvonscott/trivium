class Game

    attr_accessor :game_number, :player, :score, :turn, :difficulty

    @@all = []

    def initialize(game_number, player, difficulty, amount, category)
        @game_number = game_number
        @score = 0
        @turn = 1
        @missed_questions = []
        @incorrect_answers =[]
        self.player=(player)
        API.get_trivia(difficulty, amount, category)
        save
    end

    def save
        unless @@all.include?(self)
            @@all << self
        end
    end

    def self.all
        @@all
    end

    def player=(player)
        @player = player
        player.add_game(self)
    end

    def log_missed_question(question)
        @missed_questions << question
    end

    def missed_questions
        @missed_questions
    end

    def turn
        @turn
    end

    def score
        @score
    end

    def randomize_answers(correct, incorrect)
        randomized = []
        randomized << correct
        incorrect.each do |answer|
            randomized << answer
            end
        randomized.sample(4).each.with_index(1) do |answers, index|
            puts "#{index}. #{answers}"
            end 
        end
end