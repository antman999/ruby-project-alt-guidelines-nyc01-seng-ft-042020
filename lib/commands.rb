class CommandLineInterface

def younguser
    puts "come back with your parent"
end

def welcome
    puts "Howdy, welcome to GALAXY VIDEO GAMES the best online video game rental service in the entire galaxy."
    puts
    puts
    puts "Shall we begin on your quest to get you a game?"
 end 
  
 def get_name
     puts
     puts "To start im going to need your name. Please enter it."
     STDIN.gets.chomp
   end

   def start
    name = get_name
       puts "Welcome #{name},"
             puts "im also going to need your age for ESRB purposes"
                puts 
                age = STDIN.gets.chomp.to_i
         if age > 17 
            puts "Welcome Jedi, how can we help you today?"
            menu
        elsif age < 4 
            puts "Hey little buddy. Im not going be able to rent you a game until you have a parent with you"
            younguser

        elsif age < 17
        puts "Welcome Jedi, how can we help you today?"
        menu
      end
   end
   def menu
    puts" 
    1. Rent A Game
    2. View My Games
    3. Return A Game
    
    "
    output = STDIN.gets.chomp.to_i
    if output == 1 
        rentgame
    elsif output == 2
        viewmygames
    elsif output == 3
        returnagame
    elsif output > 4
        puts"Hey you found an easter egg! we are going to send you a big cookie of your choice after you make a valid choice."
        menu
    end
   end



end