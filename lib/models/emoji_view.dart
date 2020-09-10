//import 'package:emojis/emojis.dart'; // to use Emoji collection
import 'package:emojis/emoji.dart'; // to use Emoji utilities

Map<String, String> myEmojis = {
  'Happy': 'Grinning Face',
  'Tired': 'Tired Face',
  'Anxious': 'Anxious Face with Sweat',
  'Sad': 'Crying Face',
  'Lonely': 'Face Without Mouth',
  'Proud': 'Smiling Face with Smiling Eyes',
  'Hopeful': 'Star-Struck',
  'Frustrated': 'Pensive Face',
  'Guilty': 'Lying Face',
  'Disgust': 'Nauseated Face',
  'Bored': 'Unamused Face',
  'Physical Pain': 'Confounded Face',
  'Intrusive Food Thoughts': 'Zipper-Mouth Face',
  'Dizzy / Headache': 'Dizzy Face',
  'Irritable': 'Face with Steam From Nose',
  'Angry': 'Angry Face',
  'Depressed': 'Frowning Face',
  'Motivated': 'Winking Face',
  'Excited': 'Astonished Face',
  'Grateful': 'Folded Hands',
  'Joy': 'Grinning Squinting Face',
  'Loved': 'Smiling Face with Heart-Eyes',
  'Satisfied': 'Smiling Face',
  'Fearful': 'Fearful Face',
  'Dynamic': 'Flexed Biceps',
};

String getEmojiTextView(String input) {
  var result = Emoji.byName(myEmojis[input]);
  if (result != null)
    return result.char;
  else
    return '';
}
