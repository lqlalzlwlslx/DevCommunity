<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<!DOCTYPE html>
<html>
<style>
#myProgress {
  position: relative;
  width: 100%;
  height: 30px;
  background-color: #ddd;
}

#myBar {
  position: absolute;
  width: 1%;
  height: 100%;
  background-color: #4CAF50;
}
</style>
<body>

<div id="myProgress">
  <div id="myBar"></div>
</div>
<br>
<div align="center"><span>처리가 완료되면 자동으로 창이 닫힙니다. 강제로 종료하지 마십시오.</span></div>
<script>
function move() {
  var elem = document.getElementById("myBar");   
  var width = 1;
  var id = setInterval(frame, 10);
  function frame() {
    if (width >= 99) {
      //clearInterval(id);
      width = 1;
    } else {
      width++; 
      elem.style.width = width + '%'; 
    }
  }
}
window.onload = function(){
	move();
};
</script>

</body>
</html>
