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

Responses are JSON formatted https://stickeroid.com/bot?c=3&k=d147203e&s=hello&w=256<br>
<b>C</b> - number of output objects
<b>K</b>  - personal secret key number<br>
<b>S</b>  - search query<br>
<b>I</b>  - id of object<br>
<b>W</b>  - width of object<br>
<b>H</b>  - height of object<br>
<b>Next</b>  - next query/session for other sticker<br>
<b>Prev</b>  - previous query/session<br>

/OUTPUT

<b>Title</b>  - main title of object<br>
<b>Id</b>  - personal unique number<br>
<b>Img</b>  - url of original object<br>
<b>Thumb</b>  - url of thumbnail object<br>
<b>Format/Img</b> </b>  - .png/.jpg<br>
<b>Format/Thumb</b>  - .png/.jpg<br>
<b>Error </b> - wrong session<br>
<b>Error 1</b>  - query rate limit exceeded<br>
<b>Error 666</b>  - blocked account<br>
