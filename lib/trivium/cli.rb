class CLI

    def start
        puts "\nWelcome to the world's most basic trivia game!!!"
        menu
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

    def game_options
        valid_choices = ['easy','medium','hard']
        puts "\nGreat! What difficulty would you like to play at?"
        puts "Please enter 'easy', 'medium', or 'hard'"
        user_input = gets.strip.downcase
        if valid_choices.include?(user_input)
            @difficulty = user_input
            play_game
        else
            puts "\nGet your cat off the keyboard... please enter a valid option!"
            game_options
        end
    end

    def play_game
        Game.new(@difficulty)
    end
end