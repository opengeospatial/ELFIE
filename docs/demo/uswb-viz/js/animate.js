function clicklink(url, event){
 if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
   event.stopPropagation();
  }else{
    ga('send', 'event', 'outbound', 'click', url);
    window.open(url, '_blank');
  }
}

 
function setEmphasis(id) {
  $(".emphasis").removeClass("emphasis");
  hovertext(" ");
  $('[id$=' + id + ']').addClass('emphasis');
}

function setShow(id) {
  $(".rightSideContent").removeClass("hide_span");
  $("#characteristics").removeClass("hide_span");
  $(".showIt").addClass("nill");
  $(".showIt").removeClass("showIt");
  $(".show_span").addClass("hide_span");
  $(".show_span").removeClass("show_span");
  $('[id$=' + id + ']').removeClass("nill");
  $('[id$=' + id + ']').addClass('showIt');
  $('[id$=' + id + ']').removeClass("hide_span");
  $('[id$=' + id + ']').addClass('show_span');
  gtag('event', 'change_watershed', {'watershed': 'user switched watershed'});
}

var hus = ["070700051701","031601130201","160201020603","020401050911","102600080802","180201041203","170601080803","150302040410","101102050210","120302030102","130201011304","051202021001","050200050808","140100051906","100301012008","170900120202","180400012103","010300032404","102200031006","071000091206","030701060405","030300050405","110100040606","100800071208","150100120904"];
var default_hu = hus[Math.floor(Math.random() * hus.length)];

function load_default() {
  setEmphasis(default_hu);
  setShow('wb-id-' + default_hu);
}