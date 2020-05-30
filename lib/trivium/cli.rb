class CLI

    attr_accessor :player_name

    def start
        puts "======================================================================================="
        puts "\nWELCOME TO THE WORLD'S MOST BASIC TRIVIA GAME!!!"
        API.get_categories
        Category.new(id: 0, name: "Mixed")
        puts "\nPlease enter your player name"
        user_input = gets.strip.downcase
        @player_name = user_input    
        menu
    end

    def menu
        binding.pry
        puts "\nTRIVIUM CONTROLS: YES or NO menu selections can be chosen with 'yes','y','no', or 'n'."
        puts "\nAre you ready to play #{@player_name}?"
        user_input = gets.strip.downcase
        if user_input == "yes" || user_input == "y"
            game_options
        elsif user_input == "no" || user_input == "n"
            puts "\nGoodbye #{@player_name}!"
        else
            puts "\nGet your cat off the keyboard... please enter a valid option!"
            menu
        end

    end


    def list_categories
        @sorted_array = Category.all.sort_by do |category|
            category.name
        end
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
        puts "======================================================================================="
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
        puts "======================================================================================="
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
        puts "======================================================================================="
        puts "CHOOSE YOUR CATEGORY... OR DON'T"
        valid_category = ["list", "mixed"]
        puts "\nWould you like to choose a single category for the game?"
        puts "\nEnter 'list' to display category options or 'mixed' to continue without."
        user_input = gets.strip.downcase
            if valid_category.include?(user_input)
                if user_input == 'list'
                    list_categories
                    puts "Please choose the number of the desired category"
                        valid_choice = (1..24)
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
        puts "======================================================================================="
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
        Player.find_or_create_by_name(@player_name)
        Game.new(@player_name, @difficulty, @amount, @category)
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts "A NEW GAME HAS STARTED!"
            puts "\nPress enter to continue"
            gets.strip
            play(Question.all)
    end

    def continue_quit
        puts "\nPress enter to continue"
        puts "\nType 'quit' to quit Trivium"
        user_input = gets.strip.downcase
        if user_input == 'quit'
            exit!
        else
        end
    end

    def play(questions)
        questions.each do |question|
            puts "---------------------------------------------------------------------------------------"
            puts  "\nQuestion #{@turn}..."
            puts "--------------------"
            puts question.text.upcase
            puts "\nChoose your answer below:"
            puts "--------------------"
            options = randomize_answers(question.correct_answer, question.incorrect_answers)
            puts "--------------------"
            puts "\nEnter your answer now (as a number)"
            user_input = gets.strip.to_i - 1
                if options[user_input] == question.correct_answer
                    @score = @score + 1
                    puts Rainbow("\nCORRECT!").green
                    puts "\nGood job, NERD!"
                    continue_quit
                    puts "---------------------------------------------------------------------------------------"
                else 
                    log_missed_question(question.text)
                    puts Rainbow("\nINCORRECT!").red
                    puts "\nThe correct answer was #{question.correct_answer}"
                    puts "\nMaybe you're not great with #{question.category}..."
                    continue_quit
                    puts "---------------------------------------------------------------------------------------"
                end
                    @turn = @turn + 1
        end
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        puts "\nGAME OVER"
        puts "Press enter to see your score"
        gets.strip
        game_results
    end

    def game_results
        puts "\nYour score is #{@score} out of #{Question.all.size}"
        puts "\nWould you like to see questions you answered incorrectly? Find out what else you can learn!"
            user_input = gets.strip.downcase
            if user_input == "yes" || user_input == "y"
                missed_questions
            else
                puts "\nOk, fine then."
            start_over
            end
    end

    def missed_questions
        @missed_questions.each.with_index(1) do |question, index|
            puts "\n#{index}. #{question}"
        end
        puts "\nPress enter to continue"
            gets.strip
            start_over
    end

    def start_over
        puts "\nWould you like to play again?"
        user_input = gets.strip.downcase
            if user_input == "yes" || user_input == "y"
                puts "TRIVIA IS LIFE"
                Question.destroy_all
                # CLI.new.start
            else
                puts "OK, fine then...."
            end
    end

end