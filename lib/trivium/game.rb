class Game

    attr_accessor :player, :score, :turn, :difficulty, :missed_questions

    def initialize(player, difficulty, amount, category)
        @score = 0
        @turn = 1
        @missed_questions = []
        self.player=(player)
        API.get_trivia(difficulty, amount, category)
    end

    def player=(player)
        @player = player
        player.add_game.(self)
    end


    def log_missed_question(question)
        @missed_questions << question
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