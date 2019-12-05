# twentyone.rb

require 'pry'

# Constants
RANK = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
SUIT = ['♣', '♥', '♠', '♦']
VALUE = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7, '8' => 8,
          '9' => 9, '1' => 10, 'J' => 10, 'Q' => 10, 'K' => 10, 'A' => 11 }
ESCAPE = 'x'
FIRST_TO = 5
GAME_MAX = 31


# Methods
def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck(ranks, suits)
  cards = []
  ranks.each do |rank|
    suits.each do |suit|
      cards << "|#{rank + suit}|"
    end
  end
  cards.shuffle!
end

def reset_screen
  puts "\e[H\e[2J"
end

def dealer_initial_cards(deck)
  dealer_cards = []
  dealer_cards << deck.pop
  dealer_cards << deck.pop
  dealer_cards
end

def dealer_cards(deck)
  dealer_initial_cards(deck)
end

def player_initial_cards(deck)
  player_cards = []
  player_cards << deck.pop
  player_cards << deck.pop
  player_cards
end

def hit_me(deck, player_cards)
  player_cards << deck.pop
  player_cards
end

def display_initial_table(player, dealer_cards, player_cards, player_total)
  puts "                TWENTY ONE!                "
  puts "___________________________________________"
  puts "|                                          |"
  puts "| Dealer:  #{dealer_cards[0]}|  |"
  puts "|                                          |"
  puts "| Dealer total: #{value_of_card(dealer_cards[0][1])}"
  puts "|__________________________________________|"
  puts "|                                          |"
  puts "| #{player}:  #{player_cards.join}"
  puts "|                                          |"
  puts "| Current total: #{player_total}"
  puts "|__________________________________________|"
  spacer
end

def spacer
  puts "----------------------------"
end

def display_table(player, dealer_cards, player_cards, dealer_total,
                  player_total)
  puts "                TWENTY ONE!                "
  puts "___________________________________________"
  puts "|                                          |"
  puts "| Dealer:  #{dealer_cards.join}"
  puts "|                                          |"
  puts "| Dealer total: #{dealer_total}"
  puts "|__________________________________________|"
  puts "|                                          |"
  puts "| #{player}:  #{player_cards.join}"
  puts "|                                          |"
  puts "| Current total: #{player_total}"
  puts "|__________________________________________|"
  spacer
end

def get_total(cards)
  total = 0
  ace_count = 0
  cards.each do |card|
    if VALUE.values_at(card[1]) == [11]
      total += 11
      ace_count += 1
    else
      total += VALUE.values_at(card[1])[0]
    end
  end

  while ace_count > 0
    total = when_ace(total)
    ace_count -= 1
  end

  total
end

def when_ace(total)
  if total > GAME_MAX
    total -= 10
  end
  total
end

def value_of_card(card)
  VALUE.values_at(card).join.to_i
end

def choose_option
  prompt "Would you like to hit or stay? ('h' or 's')"
  gets.chomp.downcase
end

def exit_prompt
  spacer
  prompt "x to exit. Anything else to play again"
  spacer
  gets.chomp.downcase
end

def valid_name?(name)
  name.length > 10 || name.length < 2 || name =~ /[^A-Za-z0-9]+/
end

def check_total(total)
  if total > GAME_MAX
    :bust
  elsif total == GAME_MAX
    :twenty_one
  elsif total < GAME_MAX
    :below_twenty_one
  end
end

def get_result(player_total, dealer_total)
  if player_total > dealer_total
    :player_wins
  elsif player_total < dealer_total
    :dealer_wins
  elsif player_total == dealer_total
    :tie
  end
end

def display_result(player_total, dealer_total, name)
  result = get_result(player_total, dealer_total)

  case result
  when :player_wins
    spacer
    prompt "Congratulations #{name}!! You have beaten the dealer."
  when :dealer_wins
    spacer
    prompt "Sorry #{name}. The dealer has beaten you."
  when :tie
    spacer
    prompt "It's a tie!"
  end
end

def display_early_win_bust(total, name = 'Dealer')
  result = check_total(total)

  case result
  when :bust
    if name == 'Dealer'
      prompt "The Dealer has busted.You win!"
    else
      display_player_bust(total)
    end
  when :twenty_one
    if name == 'Dealer'
      prompt "Dealer has #{GAME_MAX}."
    else
      prompt "You have #{GAME_MAX}! Lets see what the dealer has."
    end
  end
end

def display_dealer_win_message(dealer_total)
  spacer
  prompt "Sorry, but the dealer has #{dealer_total}. You lose."
  spacer
end

def display_dealer_checking
  prompt "Checking to see if dealer has black jack....."
  sleep 3 # seconds
end

def display_dealer_turn
  spacer
  prompt "Dealers turn..."
  spacer
  sleep 3
end

def display_dealer_hit
  spacer
  prompt "Dealer has hit..."
  spacer
  sleep 3
end

def display_player_total(total)
  spacer
  prompt "Your current total is #{total}"
end

def display_dealer_total(total)
  spacer
  prompt "The dealer has #{total}"
end

def display_continue_message
  prompt "Dealer does not have Black jack! Let's continue!"
  spacer
end

def display_player_bust(total)
  prompt "Your total is #{total}"
  prompt "Sorry but you have busted."
end

def name_prompt
  spacer
  prompt "Please enter a user name: "
  prompt "Letters & Numbers only"
  prompt "Minimum of 2 characters & Maximum of 10 characters"
  spacer
end

def counter_prompt(player_wins_count, dealer_wins_count, name)
  spacer
  prompt "The score is:"
  prompt "#{name}: #{player_wins_count}"
  prompt "Dealer: #{dealer_wins_count}"
  spacer
  prompt "Hit enter to continue"
  gets.chomp
end

def display_grand_winner(player_wins_count, dealer_wins_count, name)
  if player_wins_count == FIRST_TO
    spacer
    prompt "CONGRATULATIONS #{name}! You have beaten the dealer in a first to "\
           "#{FIRST_TO}."
    spacer
    sleep 3
  elsif dealer_wins_count == FIRST_TO
    spacer
    prompt "Sorry, but the dealer has beaten #{name} in a race to "\
           "#{FIRST_TO}."
    spacer
  end
end

def first_to_prompt(name)
  prompt "The name of the game is closest to #{GAME_MAX}"
  prompt "First to #{FIRST_TO} wins is the grand winner."
  prompt "Goodluck #{name}!"
  sleep 3
end

# Local Variables
name = ''

# Algorithm
spacer
prompt "Welcome to Twenty-One!"
spacer
prompt "For a full list of rules please enter 'r'. Otherwise hit enter to "\
       "continue."
rules = gets.chomp.downcase

if rules == 'r'
  reset_screen
  File.open("twenty_one_rules.txt").each do |line|
    puts line
  end
  prompt "Hit enter to continue."
  gets.chomp
  reset_screen
end

reset_screen

loop do
  name_prompt
  name = gets.chomp

  if valid_name?(name)
    prompt "Invalid name entry."
  else
    break
  end
end

loop do
  first_to_prompt(name)
 
  player_wins_count = 0
  dealer_wins_count = 0
  
  loop do
    player_wins = false
    dealer_wins = false
    
    if player_wins_count != 0 || dealer_wins_count != 0
      counter_prompt(player_wins_count, dealer_wins_count, name)
    end
    
    if player_wins_count == FIRST_TO || dealer_wins_count == FIRST_TO
      display_grand_winner(player_wins_count, dealer_wins_count, name)
      break
    end
    
    deck = []
    dealer_cards = []
    player_cards = []
    player_total = 0
    dealer_total = 0
    action = ''
    p_check_total = 0
    d_check_total = 0
  
    reset_screen
    deck = initialize_deck(RANK, SUIT)
    dealer_cards = dealer_initial_cards(deck)
    player_cards = player_initial_cards(deck)
    dealer_total = get_total(dealer_cards)
    player_total = get_total(player_cards)
    display_initial_table(name, dealer_cards, player_cards, player_total)
  
    loop do
      p_check_total = check_total(player_total)
  
      if p_check_total == :twenty_one
        prompt "Black Jack!!! #{name} Wins!"
        player_wins = true
        break
      elsif value_of_card(dealer_cards[0][1]) == 10 ||
            value_of_card(dealer_cards[0][1]) == 11
        display_dealer_checking
        d_check_total = check_total(dealer_total)
  
        case d_check_total
        when :twenty_one
          reset_screen
          display_table(name, dealer_cards, player_cards, dealer_total,
                        player_total)
          display_dealer_win_message(dealer_total)
          dealer_wins = true
          break
        else
          display_continue_message
        end
      end
  
      loop do
        display_player_total(player_total)
        action = choose_option
  
        case action
        when 'h'
          hit_me(deck, player_cards)
          reset_screen
          player_total = get_total(player_cards)
          display_initial_table(name, dealer_cards, player_cards, player_total)
          p_check_total = check_total(player_total)
          display_early_win_bust(player_total, name)
          break unless p_check_total == :below_twenty_one
        when 's'
          break
        else
          prompt "Invalid Entry. Please enter a valid option:"
        end
      end
      
      if p_check_total == :bust
        dealer_wins = true 
        break
      end  
      display_dealer_turn
  
      loop do
        reset_screen
        display_table(name, dealer_cards, player_cards, dealer_total,
                      player_total)
        display_dealer_total(dealer_total)
  
        if dealer_total < GAME_MAX - 4
          hit_me(deck, dealer_cards)
          display_dealer_hit
          dealer_total = get_total(dealer_cards)
          reset_screen
          display_table(name, dealer_cards, player_cards, dealer_total,
                        player_total)
          d_check_total = check_total(dealer_total)
          display_early_win_bust(dealer_total)
          break unless d_check_total == :below_twenty_one
        elsif dealer_total >= GAME_MAX - 4
          prompt "The dealer stays."
          break
        end
      end
      
      if d_check_total == :bust
        player_wins = true
        break
      end
      
      temp = get_result(player_total, dealer_total)
      case temp
      when :player_wins
        player_wins = true
      when :dealer_wins
        dealer_wins = true
      end
      
      display_result(player_total, dealer_total, name)
      break
    end
   
    if player_wins == true
      player_wins_count += 1
    elsif dealer_wins == true
      dealer_wins_count += 1
    end
  end

  escape_command = exit_prompt
  break if escape_command == ESCAPE
end
