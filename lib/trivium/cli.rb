class CLI

    def start
        line_border
        puts "\nWELCOME TO THE WORLD'S MOST BASIC TRIVIA GAME!!!"
        sort_categories
        choose_player
        menu
    end

    def choose_player
        puts "\nPlease enter your player name"
        user_input = gets.strip.upcase
        @player_name = Rainbow(user_input).cyan
        @player = Player.find_or_create_by_name(@player_name)
    end

    def menu
        puts "\nWelcome #{@player_name}!"
        puts "\nTRIVIUM CONTROLS: YES or NO menu selections can be chosen with 'yes','y','no', or 'n'."
        puts "\nAre you ready to play #{@player_name}?"
        user_input = 0
            until ['yes','y','n','no'].include? user_input do
                puts "Please enter a valid option."
                user_input = gets.strip.downcase
            end
            if user_input == "yes" || user_input == "y"
                game_options
            else 
                puts "\nGoodbye #{@player_name}!"
            end

    end

    def sort_categories
        API.get_categories
        Category.new(id: 0, name: "Mixed")
         @sorted_array = Category.all.sort_by do |category|
                category.name
            end
        end


    def list_categories
        @sorted_array.each.with_index(1) do |category, index|
            puts "#{index}. #{category.name}"
        end
    end

    def game_options
        choose_difficulty
        choose_question_amount
        choose_category
        confirm_options
    end

    def choose_difficulty
        line_border
        puts "CHOOSE YOUR DIFFICULTY"
        valid_difficulty = ['easy','medium','hard']
        puts "\nWhat difficulty would you like to play at?"
        puts "\nPlease enter 'easy', 'medium', or 'hard'"
        user_input = gets.strip.downcase
        if valid_difficulty.include?(user_input)
            @difficulty = user_input
        else
            puts "\nGet your cat off the keyboard... please enter a valid option!"
            choose_difficulty
        end
    end

    def choose_question_amount
        line_border
        puts "CHOOSE YOUR QUESTION COUNT"
        valid_amount = (1..25)
        puts "\nHow many questions would you like in your game? Choose up to 25"
        user_input = gets.strip.to_i
        if valid_amount.include?(user_input)
            @amount = user_input
        else 
            puts "Let's try again "
            choose_question_amount
        end
    end

    def choose_category
        line_border
        puts "CHOOSE YOUR CATEGORY... OR DON'T"
        valid_category = ["list", "mixed"]
        puts "\nWould you like to choose a single category for the game?"
        puts "\nEnter 'list' to display category options or 'mixed' to continue without."
        user_input = gets.strip.downcase
            if valid_category.include?(user_input)
                if user_input == 'list'
                    list_categories
                    puts "Please choose the number of the desired category"
                        valid_choice = (1..25)
                        user_input = gets.strip.to_i
                        if valid_choice.include?(user_input)
                            @category = @sorted_array[user_input-1].id
                        else
                            puts "Let's try again"
                            choose_category
                        end
                else
                    @category = 0
                end
            else
                puts "Let's try again."
                choose_category
            end
    end

    def id_name(id)
        Category.all.find do |category|
            if category.id == id
                return category.name
            else
            end
        end
    end

    def confirm_options
        line_border
        puts "CONFIRM YOUR CHOICES"
        puts "\nYou're playing on #{@difficulty}, with #{@amount} questions from the #{id_name(@category)} category? Are you sure, #{@player_name}?"
            puts "\nType 'back' to choose again"
            puts "\nPress enter to continue"
            user_input = gets.strip.downcase
            if user_input == "back"
                game_options
            end
            start_game
    end

    def start_game
        @game_number = "Game #{@player.games.size + 1}"
        @current_game = Game.new(@game_number, @player, @difficulty, @amount, @category)
        squiggle_border
        puts "\nA NEW GAME HAS STARTED!"
            continue
            play(Question.all)
    end

    def continue
        puts "\nPress enter to continue"
        gets.strip
    end

    def play(questions)
        questions.each do |question|
            line_border
            puts  "\nQuestion #{@current_game.turn}..."
            puts "--------------------"
            puts question.text.upcase
            puts "\nChoose your answer below:"
            puts "--------------------"
            options = @current_game.randomize_answers(question.correct_answer, question.incorrect_answers)
            puts "--------------------"
                user_input = 0
                until [1,2,3,4].include? user_input do
                    puts "Please enter a valid option."
                    user_input = gets.strip.to_i
                end
                if options[user_input - 1] == question.correct_answer
                    @current_game.score = @current_game.score + 1
                    puts Rainbow("\nCORRECT!").green
                    puts "\nGood job, NERD!"
                    continue
                    line_border
                else 
                    @current_game.log_missed_question(question)
                    puts Rainbow("\nINCORRECT!").red
                    puts "\nThe correct answer was" + Rainbow(" #{question.correct_answer}").green
                    puts "\nMaybe you're not great with #{question.category}..."
                    continue
                    line_border
                end
            @current_game.turn = @current_game.turn + 1
        end
        squiggle_border
        puts "\nGAME OVER"
        continue
        game_results
    end    

    def game_results
        line_border
        @player.scores << "#{@game_number} was a part of the #{id_name(@category)} category and the final score was #{@current_game.score} out of #{Question.all.size}!"
        puts "\nYour score is #{@current_game.score} out of #{Question.all.size}"
        puts "\nWould you like to see all of your Trivium scores?"
            user_input = gets.strip.downcase
                if user_input == "yes" || user_input == "y"
                    all_scores
                else
                    puts "\nOk, fine!"
                    continue
                end
        line_border
        puts "\nWould you like to see questions you answered incorrectly? Find out what else you can learn!"
            user_input = gets.strip.downcase
                if user_input == "yes" || user_input == "y"
                    missed_questions
                else
                    puts "\nOk, fine!"
                    continue
                    start_over
            end
    end

    def missed_questions
        line_border
        @current_game.missed_questions.each.with_index(1) do |question, index|
            puts "\n#{index}. #{question.text}"
            puts "\nCorrect answer:" + Rainbow(" #{question.correct_answer}").green
        end
            continue
            start_over
    end

    def all_scores
        line_border
        puts "\n#{@player_name}'s Trivium games:"
            @player.scores.each do |score|
            puts score
        end
    end

    def start_over
        Question.destroy_all
        line_border
        puts "\nWould you like to play again?"
        puts "Choose your option"
        puts "1. Yes, play again with the same game options"
        puts "2. Yes, but let me change my game options"
        puts "3. Yes, but let me play as a different player"
        puts "4. No thanks"
            user_input = 0
                until [1,2,3,4].include? user_input do
                    puts "Please enter a valid option."
                    user_input = gets.strip.to_i
                end
                case user_input
                when 1
                    puts "\nTRIVIA IS LIFE"
                    confirm_options
                when 2
                    puts "\nLET'S CHANGE IT UP!"
                    game_options
                when 3
                    puts "\nPLAYER 2 LET'S DO IT!"
                    start
                else 
                    puts "\nOK, fine!"
                end
    end

    def squiggle_border
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    end

    def line_border
        puts "======================================================================================="
    end

end