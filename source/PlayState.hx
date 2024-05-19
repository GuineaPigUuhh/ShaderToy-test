package;

import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;
import FlxShaderToyHack;
import openfl.filters.ShaderFilter;

class PlayState extends FlxState
{
	var text:FlxText;

	override public function create()
	{
		super.create();

		text = new FlxText(0, 0, 0, "Hello World", 64);
		text.screenCenter();
		add(text);

		/**
		 * Shader
		 * @see https://www.shadertoy.com/view/MsjXDm
		 */
		var shader = new FlxShaderToyHack('
		#define time iTime*10.


		float stripe(vec2 uv) {
			return cos(uv.x*20.-time+uv.y*-30.);
		}
		
		float glass(vec2 uv) {
			return cos(dot(uv.xy, vec2(12.41234,2442.123))*cos(uv.y));
		}
		
		
		void mainImage( out vec4 fragColor, in vec2 fragCoord )
		{
		
			vec2 uv = fragCoord.xy / iResolution.xy;
			float a = iResolution.x/iResolution.y;
			uv.x *= a;
			
		
			float g = stripe(uv);
		
			
			vec3 col = vec3(smoothstep(0., .2, g));
		
			col.r = .8;
			col /= (pow(glass(vec2(uv.x*30., uv.y)),2.))+.5;
			
		  
			//Mask sides
			col *= smoothstep(.12, .0, abs(uv.x - .5*a));
		
			//Mask top and bottom
			col *= smoothstep(.33, .30, abs(uv.y - .5));
		
			if (uv.y > .80 && uv.y < .94 || uv.y < .2 && uv.y >.06) {
			   col = vec3(smoothstep(.13, .0, abs(uv.x - .5*a)));
			
			}
		
			if (uv.y > .77 && uv.y < .87 || uv.y < .23 && uv.y >.13) {
			   col = vec3(smoothstep(.15, .0, abs(uv.x - .5*a)));
				
			}
		
			fragColor = vec4(col,1.0);
		}');

		FlxG.camera.filters = [new ShaderFilter(shader)];
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.UP)
		{
			text.y -= 2;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			text.y += 2;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			text.x -= 2;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			text.x += 2;
		}
	}
}
