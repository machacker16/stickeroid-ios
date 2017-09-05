<img src="https://stickeroid.com/files/covergit.png" alt="Stickeroid">
Stickeroid is designed to be extremely simple to use, despite the complexity of the algorithms running under the hood. It consists of a set of HTTPS endpoints, when sending requests to these endpoints, set the x-api-key: API_KEY header on your request, replacing API_KEY with your key.

Programmable API made this process really easy to implement for next generation app. It’s a great value for us because it saved ton of product development time.

Our text-to-sticker solution can translate more than 250,000 word variations with the highest accuracy.

About Translator - https://stickeroid.com/translator<br>
Pricing - https://stickeroid.com/pricing<br>
Terms - https://stickeroid.com/terms<br>
Privacy - https://stickeroid.com/privacy<br>


Get your a secret key -  <a href="https://www.facebook.com/v2.9/dialog/oauth?client_id=1790878371234099&amp;state=976337beb8352376cdf00131eb98135f&amp;response_type=code&amp;sdk=php-sdk-5.5.0&amp;redirect_uri=https%3A%2F%2Fstickeroid.com%2Fninja-applications%2Fuser%2Ffacebook%2Ffblogin5.5.php&amp;scope=public_profile%2Cemail">here</a>

/API

Responses are JSON formattedHTTPS://STICKEROID.COM/BOT?C=&S=&I=&W=7&S=7<br>
<span style="color:red">C</span> - number of output objects
K - personal secret key number<br>
S - search query<br>
I - id of object<br>
W - width of object<br>
H - height of object<br>
Next - next query/session for other sticker<br>
Prev - previous query/session<br>

/OUTPUT

Parameters and attributesFOR BOT/SEARCH PROGRAMMABLE API<br>
Title - main title of object<br>
Id - personal unique number<br>
Img - url of original object<br>
Thumb - url of thumbnail object<br>
Format/Img - .png/.jpg<br>
Format/Thumb - .png/.jpg<br>
Error - wrong session<br>
Error 1 - query rate limit exceeded<br>
Error 666 - blocked account<br>
