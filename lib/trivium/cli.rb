class CLI

    def start
        puts "======================================================================================="
        puts "\nWELCOME TO THE WORLD'S MOST BASIC TRIVIA GAME!!!"
        API.get_categories
        Category.new(id: 0, name: "mixed")    
        menu
    end

    def menu
        puts "\nTRIVIUM CONTROLS: YES or NO menu selections can be chosen with 'yes','y','no', or 'n'."
        puts "\nAre you ready to play?"
        user_input = gets.strip.downcase
        if user_input == "yes" || user_input == "y"
            game_options
        elsif user_input == "no" || user_input == "n"
            puts "\nGoodbye!"
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
            puts "#{index} #{category.name}"
        end
    end

    def game_options
        choose_difficulty
        choose_question_amount
        choose_category
        confirm_options
        play_game
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
        puts "\nYou're playing on #{@difficulty}, with #{@amount} questions from the #{id_name(@category)} category? Are you sure?"
            puts "Type 'back' to choose again"
            puts "Press enter to continue"
            user_input = gets.strip.downcase
            if user_input == "back"
                game_options
            end
    end

    def play_game
        Game.new(@difficulty,@amount,@category)
    end
end