#IMP: I decided to use a hash for the deck and the players hands.
#This changes the code quite substantially compare to Chris solution.

#Chooses a card from the deck randomly, updates the deck and adds it to the corresponding player hand
def deal_card(current_deck,hand)
  suit=current_deck.keys.sample
  number=current_deck[suit].sample
  current_deck[suit].delete(number)
  hand[suit] << number
end

#Calculate the value of a hand (hash) that it's been passed in.
def calculate_score(hand)
  total_value=0
  ace_counter=0
  #Goes through the whole hand (hash). Adds the value of the cards with mumbers, adds +10 for Jacks,Queens and Kings
  #It does not add the values of aces yet but keep track of how many there are in hand.
  hand.each do |k,values|
    values.each do |value|
      if value=="Jack"|| value=="Queen" || value=="King"
        total_value+=10
      elsif value.class==Fixnum
        total_value+=value
      else
        ace_counter+=1
      end
    end   
  end
  # Aces value are estimated after adding the other cards with fixed value. 
  # Aces value are set to 1 or 11 depending on what's more convinient for the player. 
  while ace_counter>0
    if total_value+11<=21 
      total_value+=11
    else
      total_value+=1
    end
    ace_counter-=1
  end
  
  total_value
end

#Checks if the player wants to keep playing.
#A separate method is more convinient because the game has to check this several times
def play_again
  valid_answer=false
  # The while is necesary in case that the user enters an non-valid answer (e.g ghqwerfds)
  while valid_answer==false
    puts " "
    puts "Would you like to play again: (Y/N)"
    answer=gets.chomp.capitalize
    if answer == "Y"
      valid_answer=true
      keep_playing=true
    elsif answer == "N"
      valid_answer=true
      keep_playing=false
    else
      puts "Please give me a valid answer!"
    end
  end 
  keep_playing
end

# It display the hand in a more human-readable way
def display_hand(player_name,player_hand, dealer_hand)
  puts "Welcome to my awesome BlackJack game"
  puts " "
  puts "---------#{player_name}'s hand----------"
  puts " "
  player_hand.each do |suit,values|
    values.each do |value|
      puts "#{value} of #{suit}"
    end
  end
  puts " "
  puts "Acumulated score: #{calculate_score(player_hand)}"
  puts " "

  puts "---------Dealer's hand----------"
  puts " "
  dealer_hand.each do |suit,values|
    values.each do |value|
      puts "#{value} of #{suit}"
    end
  end
  puts " "
  puts "Acumulated score: #{calculate_score(dealer_hand)}"
  puts " "
end
system('clear')
puts "Hey, before we begin tell me your name :) !"
player_name=gets.chomp.capitalize
#Main program. Controls the flow of the game
keep_playing=true
while keep_playing==true
# Initializing variables
  hit_me=true
# Deck initially has all possible cards
  deck = {hearts: [2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"], diamonds: [2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"], 
  clubs: [2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"], spades: [2,3,4,5,6,7,8,9,10,"Jack","Queen","King","Ace"] }

# Hands are initially empty
  player_hand= Hash.new{ |h,k| h[k] = [] }
  dealer_hand= Hash.new{ |h,k| h[k] = [] }
  
# Dealer deals two cards to the player and the score is calculated and displayed
  2.times{deal_card(deck,player_hand)}
  2.times{deal_card(deck,dealer_hand)}
  player_score=calculate_score(player_hand)
  dealer_score=calculate_score(dealer_hand)
  
  system("clear")
  display_hand(player_name,player_hand,dealer_hand)

#Check if dealer scored blackjack first
  if dealer_score==21
    puts "The dealer got BlackJack!. You lost and he destroyed you!"
    if play_again
      next
    else
      break
    end
  end
# Check if player scored BlackJack
  if player_score==21
    puts "You got a BlackJack! You've won"
    if play_again
      next
    else
      break
    end
  end

# Check if the player wants another card 
  while hit_me==true
    puts "Would you like another card: (Y/N)"
    another_card=gets.chomp.capitalize

    if another_card == "Y"
      deal_card(deck,player_hand)
      player_score=calculate_score(player_hand)
      system('clear')
      display_hand(player_name,player_hand,dealer_hand)
    elsif another_card == "N"
      hit_me=false
    else
      puts "Sorry I did not hear you clearly. Could you repeat?"
    end
#   Check if the player has busted
    if player_score>=21
      hit_me=false
    end
  end
  ## In order to break the main loop in case the player has busted when asked for more cards
  if player_score>21
    puts "You have busted! The dealer wins"

    if play_again
      next
    else
      break
    end
  end

  while dealer_score<17
    deal_card(deck,dealer_hand)
    dealer_score=calculate_score(dealer_hand)
  end

  system('clear')
  display_hand(player_name,player_hand,dealer_hand)

  if dealer_score>21
    puts "The dealer has busted you won"
  elsif dealer_score==21
    puts "The dealer have 21 and wins!"
  else
    if player_score>dealer_score
      puts "Your score is higher. You won"
    elsif dealer_score>=player_score  
      puts "The dealer beat you ass to the floor"
    end
  end

  if play_again
      next
  else
      break
  end
end





