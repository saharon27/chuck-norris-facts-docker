
<html>
    <head>
     <title>Chuck Norris Random Facts in HTML5</title>
     <style type="text/css">
      body {
        background-color: black;
      }
      #data {
        width: 600px;
        border: 1px dashed red;
        font-size: 20px;
        text-align: center;
        color: red;
        margin: 0 auto;
        margin-top: 50px;
        padding: 20px;
      }
      #logo {
        width: 500px;
        height: 500px;
        margin: 0 auto;
        margin-top: 50px;
        display: block;
      }
     </style>
    </head>
    <body>
      <img id="logo" src="Mighty-chucks.jpg" />
      <div id="data" />
      <script type="text/javascript">
        function randomFact() {
          // We call the Web Service via AJAX
          var xmlhttp = new XMLHttpRequest();
          var url = "https://api.chucknorris.io/jokes/random";
          xmlhttp.onreadystatechange = function() {
            if(this.readyState == 4 && this.status == 200) {
              var json = JSON.parse(this.responseText);
              // We parse the JSON response
              parseJson(json);
            }
          };
          xmlhttp.open("GET", url, true);
          xmlhttp.send();
        }
        function parseJson(json) {
          var fact = "<b>" + json["value"] + "</b>";
          document.getElementById("data").innerHTML = fact;
        }
        // Finally we add a click event listener on the logo of Chuck Norris
        // to load a new random fact when the user will click on it
        document.getElementById("logo").addEventListener("click", function() {
          randomFact();
        });
        randomFact();
      </script>
    </body>
    </html>
