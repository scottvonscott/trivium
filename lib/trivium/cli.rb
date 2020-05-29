class CLI

    def start
        puts "\nWelcome to the world's most basic trivia game!!!"
        API.get_categories
        list_categories
    
        # menu
    end

    def menu
        puts "\nTrivium Controls: YES or NO menu selections can be chosen with 'yes','y','no', or 'n'."
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
        @listed_categories = {}
        sorted_array = Category.all.sort_by do |category|
            category.name
        end
        
        sorted_array.each.with_index(1) do |category, index|
            @listed_categories = {"#{category.name}":" #{index}"}
            puts "#{index} #{category.name}"
       end
       binding.pry
    end

    def game_options
        valid_difficulty = ['easy','medium','hard']
        puts "\nGreat! What difficulty would you like to play at?"
        puts "Please enter 'easy', 'medium', or 'hard'"
        user_input = gets.strip.downcase
        if valid_difficulty.include?(user_input)
            @difficulty = user_input
        else
            puts "\nGet your cat off the keyboard... please enter a valid option!"
            game_options
        end
        puts "\nHow many questions would you like in your game?"
        user_input = gets.strip.to_i
            @amount = user_input
        puts "Would you like to choose a single category for the game?"
        puts "Enter 'list' to display category options or 'mix' to continue without."
            # if user_input == 'list'
            #     list_categories
            # else
            # end

        user_input = gets.strip.to_i
        @category = user_input
        # play_game
    end

    def play_game
        Game.new(@difficulty,@amount,@category)
    end
end