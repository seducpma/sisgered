		$(document).ready(function(){
			//Examples of how to assign the ColorBox event to elements
                        $(".outline").colorbox({inline:true,width:"3%", overlayClose: false});
                        $(".line").colorbox({inline:true, overlayClose: false});
                        $(".inline#pessoa").colorbox({inline:true ,height:"40%"});$(".inline").colorbox({inline:true ,width:"4 0%", overlayClose: false});
                        $(".inline").colorbox({inline:true ,width:"40%", overlayClose: false, onClosed:function(){$('#surge').show()}});
			$(".callbacks").colorbox({
				onOpen:function(){alert('onOpen: colorbox is about to open');},
				onLoad:function(){alert('onLoad: colorbox has started to load the targeted content');},
				onComplete:function(){alert('onComplete: colorbox has displayed the loaded content');},
				onCleanup:function(){alert('onCleanup: colorbox has begun the close process');},
				onClosed:function(){alert('onClosed: colorbox has completely closed');}
			});

		});
