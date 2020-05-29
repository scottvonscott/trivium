class Game

    attr_accessor :score, :turn, :difficulty, :missed_questions

    def initialize(difficulty)
        @score = 0
        @turn = 1
        @missed_questions = []
        API.get_trivia(difficulty)
        
        puts "\nA new game has started!"
        puts "\nYou're playing on #{difficulty}? Ok... if you say so."
            puts "Press enter to continue"
            gets.strip
            play(Question.all)
    end

    def score
        @score
    end

    def turn
        @turn
    end

    def missed_questions
        @missed_questions.each.with_index(1) do |question, index|
            puts "#{index}. #{question}"
        end
        puts "Press enter to continue"
            gets.strip
            start_over
    end

    def results
        puts "\nYour score is #{@score} out of #{Question.all.size}"
        puts "\nWould you like to see questions you answered incorrectly? Seems like a good chance to learn more!"
            user_input = gets.strip.downcase
            if user_input == "yes" || user_input == "y"
                missed_questions
            else
                puts "\nOk, fine then."
            start_over
        end
    end

    def start_over
        puts "\nWould you like to play again?"
        user_input = gets.strip.downcase
            if user_input == "yes" || user_input == "y"
                puts "TRIVIA IS LIFE"
                Question.destroy_all
                CLI.new.start
            else
                puts "OK, fine then...."
            end
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


    def play (questions)
    questions.each do |question|
        puts "-------------------------------------------------------------------------------"
        puts  "\nQuestion #{@turn}..."
        puts "--------------------"
        puts question.text
        puts "\nChoose your answer below:"
        puts "--------------------"
        options = randomize_answers(question.correct_answer, question.incorrect_answers)
        puts "--------------------"
        puts "\nEnter your answer now (as a number)"
        user_input = gets.strip.to_i - 1
            if options[user_input] == question.correct_answer
                @score = @score + 1
                puts "\nCORRECT!"
                puts "\nGood job, NERD!"
                puts "Press enter to continue."
                gets.strip
                puts "-------------------------------------------------------------------------------"

            
            else 
                @missed_questions << question.text
                puts "\nINCORRECT!"
                puts "\nThe correct answer was #{question.correct_answer}"
                puts "\nMaybe you're not great with #{question.category}..."
                puts "\nPress enter to continue"
                gets.strip
                puts "-------------------------------------------------------------------------------"

            end
                @turn = @turn + 1
        
    end
    puts "\nGAME OVER"
    puts "Press enter to see your score"
    gets.strip
    results
end


        
    

end