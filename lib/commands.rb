require "tty-prompt"
class CommandLineInterface
# attr_accessor :user_name



#start the command will check if you have an account if not you have to make one before proceeding if you are under 17 you will not be able to rent a game 

def welcome
    puts "Howdy, welcome to GALAXY VIDEO GAMES the best online video game rental service in the entire galaxy."
    puts
    puts
    puts "Shall we begin on your quest to get you a game?"
    get_name
 end 


#########create########
 def get_name
    puts
    puts "To start im going to need your name. Please enter it."
    @user_name = gets.chomp.capitalize
    check_if_guest_has_account
 end

 def check_if_guest_has_account
    name = @user_name 
    search = User.find_by(name: name)
    findauser = User.where(id: search).first
    if findauser 
        puts "Welcome back, #{name}."
        menu
    else
        puts "I dont see you have an account #{name}. In order to begin you need to make an account, also keep in mind if you're younger than 17 you wont be able to rent a game."
        new_age = gets.chomp.to_i
        if new_age >=17
        puts "also what type of games do you like? (ex shooters, role-play, sports)"
        likings = gets.chomp
        findauser = User.create(name: name, age: new_age, preference: likings)
        puts"Thank you for Making an account."
        menu
        else 
            puts "sorry buddy you are too young to rent a game come back with a parent."
     end
  end
end


###########create#########

####once signed in or created you will be taken to menu#######
def menu
    prompt = TTY::Prompt.new
    prompt.select("How can we Help you today.") do |prompt|
        prompt.enum '.'
        prompt.choice 'Rent A Game' do  rentgame end
        prompt.choice 'View My Games' do viewmygames end
        prompt.choice 'Return A Game' do returnagame end
        prompt.choice 'Update or delete a review' do updatedelete end
        prompt.choice 'Exit program' do puts "Have a great day" end
        prompt.choice 'Delete my account' do deleteaccount end
    end
end


   ###menu selections 
   def rentgame
    name = @user_name 
    search = User.find_by(name: name)
    findauser = User.where(id: search).first
    puts Game.pluck(:title)
    prompt = TTY::Prompt.new
    prompt.select("If you're ready to pick a game please copy the title of the game you'd like.") do |prompt|
        prompt.enum '.'
        prompt.choice "Yup, Im ready" do  getgame end
        prompt.choice 'No, take me back' do menu end
      end
end



   def getgame
        name = @user_name 
            search = User.find_by(name: name)
                findauser = User.where(id: search).first
                puts "Next i'm going to need the title of the game Make sure you paste it."
             game_title = gets.chomp
         search_for_game = Game.find_by(title:game_title)
    foundgame = Game.where(id:search_for_game).first
            puts "Are you sure you want to check out #{game_title}?"
                        puts
                            puts "
                            1. Yes       2. Maybe later (Main Menu)
                            "
        makesure = gets.chomp.to_i
        if makesure == 1

            g_id = foundgame.id

            u_id = findauser.id

                if Rental.find_by(game_id:g_id, user_id:u_id)
                    rental_find = Rental.all.find_by(user_id:u_id,game_id:g_id)
                    if rental_find.returned? == false 
                        puts "****ERROR****"
                        puts "Please return this game before renting out the same game."
                        menu
                    elsif rental_find
                        rental_find.update(returned?: false)
                    puts "Oops you already had the game before let me update your records"
                    puts "Congrats!! youre all done please make sure to leave an updated review when youre done."
                puts 
                prompt = TTY::Prompt.new
                prompt.select("press one to go back to the main menu") do |prompt|
                prompt.enum '.'
                prompt.choice 'Go Back' do  menu end
                end
                end
                else Rental.create(game_id:g_id, user_id:u_id)
                puts "Congrats!! youre all done please make sure to leave a review when youre done."
                puts 
                prompt = TTY::Prompt.new
                prompt.select("Press one to go back to the main menu") do |prompt|
                prompt.enum '.'
                prompt.choice 'Go Back' do  menu end
                end
                end

            elsif makesure == 2 
                menu
            end
        end


            def viewmygames
                name = @user_name 
                search = User.find_by(name: name)
                findauser = User.where(id: search).first
                returned = findauser.rentals.where(returned?:false).distinct
                        returned_game = returned.pluck(:game_id).uniq
                        final_piece = Game.where(id:returned_game).uniq
                        if findauser
                            puts "Welcome back, #{name}."
                            puts "These are all the games you have rented and have not returned"
                            puts 

                            puts final_piece.pluck(:title)
                            puts
                            puts
                        prompt = TTY::Prompt.new
                prompt.select("Please make a choice.") do |prompt|
                    prompt.enum '.'
                    prompt.choice 'Go Back' do  menu end
                    prompt.choice 'Return a Game' do returnagame end
                end
                end

            end

        def returnagame
                name = @user_name 
                search = User.find_by(name: name)
                findauser = User.where(id: search).first
                returned = findauser.rentals.where(returned?:false).uniq
                returned_game = returned.pluck(:game_id).uniq
                final_piece = Game.where(id:returned_game).uniq
                puts final_piece.pluck(:title).uniq
            puts
            prompt = TTY::Prompt.new
            prompt.select("These are the games you need to return") do |prompt|
                prompt.enum '.'
                prompt.choice 'Continue' do  returnagame1 end
                prompt.choice 'Return to the Menu' do menu end
                end
        end


def returnagame1
            name = @user_name 
            search = User.find_by(name: name)
            findauser = User.where(id: search).first
            returned = findauser.rentals.where(returned?:false).uniq
            returned_game = returned.pluck(:game_id).uniq
            final_piece = Game.where(id:returned_game).uniq
                puts "Welcome back, #{name}."
                puts
                puts
                puts "these are the games you need to return. Please copy and paste the title to return it."
                puts
                puts 
                        puts final_piece.pluck(:title).uniq
                        puts
                        puts"Paste the title below to continue."
                        game_title = gets.chomp
                        search_for_game = Game.find_by(title:game_title)
                        foundgame = Game.where(id:search_for_game).first
                        g_id = foundgame.id
                        u_id = findauser.id

            prompt = TTY::Prompt.new
            prompt.select(" before returning the game we really would appreciate your feedback on games on a 1-5 scale how would you rate your experience") do |prompt|
            prompt.enum '.'
            prompt.choice 'That game sucked.' do rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:1)end
            prompt.choice 'I would not play it again.' do    rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:2) end
            prompt.choice 'It was okay.' do rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:3) end
            prompt.choice 'I liked it.' do rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:4) end
            prompt.choice 'Do I really have to return it. It was amazing! ' do rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:5) end
            prompt.choice 'I wish not share. ' do puts rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:nil) end
        end
                puts "Thank you for your feedback #{name}."
                rental_find = Rental.all.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(returned?: true)
                puts
                puts
                puts" Thank you for returning the game we hope you enjoyed your experience. Remember you can always update your review or delete it."
                puts
                menu 
                end
    

    def updatedelete
        ###we are gonne find the game the user inputs and update or update to nil 
        puts "Thank you for coming back to give another rating to a game."
        puts
        puts
        puts
        name = @user_name 
            search = User.find_by(name: name)
            findauser = User.where(id: search).first
            returned = findauser.rentals.where(returned?: true).uniq
            returned_game = returned.pluck(:game_id).uniq
            final_piece = Game.where(id:returned_game).uniq
            puts final_piece.pluck(:title).uniq
                        puts
                        puts"Paste the title below to continue."
                        puts
                        game_title = gets.chomp
                        search_for_game = Game.find_by(title:game_title)
                        foundgame = Game.where(id:search_for_game).first
                        g_id = foundgame.id
                        u_id = findauser.id
                        prompt = TTY::Prompt.new
            prompt.select("What rating would you like to give?.") do |prompt|
            prompt.enum '.'
            prompt.choice 'That game sucked.' do rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:1)end
            prompt.choice 'I would not play it again.' do    rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:2) end
            prompt.choice 'It was okay.' do rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:3) end
            prompt.choice 'I liked it.' do rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:4) end
            prompt.choice 'This game should win game of the year!! ' do rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:5) end
            prompt.choice 'I want to delete my rating ' do puts rental_find = Rental.find_by(user_id:u_id,game_id:g_id)
                rental_find.update(rating:nil) end
        end
        puts "Thank you for your feedback #{name}."
        menu

    end

    def deleteaccount
        puts "Welcome Back, please make a choice."
        prompt = TTY::Prompt.new
        prompt.select("Are you sure you want to delete this account. as of now there's no way of getting it back") do |prompt|
            prompt.enum '.'
            prompt.choice 'Delete it!' do reallydeleteit end  
            prompt.choice 'Actually never mind' do menu end
            end
    end

    def reallydeleteit
        name = @user_name 
         search = User.find_by(name: name)
         findauser = User.where(id: search).first
        puts "Are you SURE SURE?"
        prompt = TTY::Prompt.new
        prompt.select("Theres no going back.") do |prompt|
            prompt.enum '.'
            prompt.choice 'Yes im sure' do puts "It was great doing business with you. Have a great day!", User.delete(findauser)end  
            prompt.choice 'Actually never mind' do menu end
            end
    end
end
