package com.utils {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 算法类
	 * @author taojianlong
	 * 2012.10.7
	 */
	public class MathUtils {
		
		/**
		 * 获取两个数之间的
		 */
		public static function randomCount(min:Number, max:Number):Number {
			return min + Math.round(Math.random() * (max - min));
		}
		
		/**
		 * 比较两个64位的数字是否相等
		 */
		public static function equal(a:*, b:*):Boolean {
			if (a && b) {
				if (a["high"] && b["high"]) {
					if (a.high == b.high && a.low == b.low) {
						return true;
					}
				} else {
					if (a == b) {
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 获取两个对象之间的直线距离
		 */
		public static function distance(source:*, target:*):Number {
			if (target && source) {
				return Math.sqrt(Math.pow(source.x - target.x, 2) + Math.pow(source.y - target.y, 2));
			}
			return 100000;
		}
		
		/**
		 * 曼哈顿启发函数<br/>
		 * 用此启发函数在八向寻路中找到的并不是最优路径,因为它的运算结果可能远远大于开始结点到目标结点的距离,
		 * 但是此启发函数的运算速度非常快
		 * @param x1 节点1x
		 * @param y1 节点1y
		 * @param x2 节点2x
		 * @param y2 节点2y
		 * @return 
		 * 
		 */
		public static function manhattan(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return (
				(x1 > x2 ? x1 - x2 : x2 - x1)
				+
				(y1 > y2 ? y1 - y2 : y2 - y1)
			) * 100;
		}
		
		/**
         * 点旋转角度后的位置
         * @param point 	点
         * @param cp 		中心点
         * @param angle 	角度 0 ~ 360
         * @param isDirct 	是否为顺时针
         */
        public static function rotationPoint( point:Point , cp:Point = null , angle:Number = 0 , isDirct:Boolean = true ):Point {
            
            if ( point == null ) {
                return null;
            }
            
            cp = cp || new Point();
            
            var r:Number = getDistanceAt( point , cp );
            
            var radio:Number = angleToRadian( angle ); 
            
            var p:Point = new Point();
            if ( isDirct ) {
                p.x = cp.x + Math.cos(radio) * point.x - Math.sin(radio) * point.y;
                p.y = cp.y + Math.cos(radio) * point.y + Math.sin(radio) * point.x;
            }
            else {
                p.x = cp.x + Math.cos(radio) * point.x + Math.sin(radio) * point.y;
                p.y = cp.y + Math.cos(radio) * point.y - Math.sin(radio) * point.x;
            }
            return p;
        }
		
		/**
		 * 获取在圆周上对应角度的点的位置
		 * @param	radius	半径
		 * @param	angle	角度 0 ~ 360
		 * @param	isDirct 是否为顺时针方向
		 * @return
		 */
		public static function getPointAtCircle( radius:Number = 100 , angle:Number = 0 , isDirct:Boolean = true ):Point {
			
			var p:Point = new Point();
			p.x = Math.cos(angle) * radius;
			p.y = Math.sin(angle) * radius;
			return p;
		}
		
		/**
		 * 角度转弧度
		 * @param	angle
		 * @return
		 */
		public static function angleToRadian( angle:Number ):Number {
		
			return angle * Math.PI / 180;
		}
		
		/**
		 * 弧度转角度
		 * @param	radian
		 * @return
		 */
		public static function radianToAngle( radian:Number ):Number {
		
			return radian * 180 / Math.PI;
		}
		
		/**
		 * 获取点(x0,y0)到直线的距离 ax + by + c = 0  d=|Ax0+By0+C|/√(A^2+B^2)
		 * @param	point 点
		 * @param	lineA 直线点A
		 * @param	lineB 直线点B
		 * @return
		 */
		public static function getDistancePointToLine(point:Point, lineA:Point, lineB:Point):Number {
			
			//ab线条方程 y = k * x + c 
			var k:Number = (lineA.y - lineB.y) / (lineA.x - lineB.x);
			var c:Number = lineB.y - k * lineB.x;
			
			var a:Number = k;
			var b:Number = -1;
			
			var dic:Number;
			if (k == 0) {
				dic = Math.abs(point.y - lineA.y);
			} else if (k == Infinity) {
				dic = Math.abs(point.x - lineA.x);
			} else {
				dic = Math.abs(a * point.x + b * point.y + c) / Math.sqrt(a * a + b * b);
			}
			return dic;
		}
		
		/**
		 * 获取点到线段ab的反射点
		 * @param	point 要反射的点
		 * @param   insterPoint //获取点到线段的交点
		 * @param	lineA //线条ab两点
		 * @param	lineB
		 * @return
		 */
		public static function getrReflectPoint(point:Point, insterPoint:Point, lineA:Point, lineB:Point):Point {
			
			//ab线条方程 y = k1 * x + b1 
			var k1:Number = (lineA.y - lineB.y) / (lineA.x - lineB.x);
			
			var k2:Number;
			//垂线方程 y = k2 * x + c 
			var c:Number;
			//求出垂线abc值
			var a2:Number;
			var b2:Number;
			var c2:Number;
			if (k1 == 0) {
				
				k2 = Infinity;
				
				a2 = k2;
				b2 = -1;
				c2 = Infinity;
			} else if (Math.abs(k1) == Infinity) {
				
				k2 = 0;
				
				a2 = k2;
				b2 = -1;
				c2 = insterPoint.y;
			} else {
				
				k2 = -1 / k1;
				
				a2 = k2;
				b2 = -1;
				c2 = insterPoint.y - k2 * insterPoint.x;
			}
			
			var symmetricPoint:Point = getSymmetricPointCrossLine(point, insterPoint, a2, b2, c2);
			return symmetricPoint;
		}
		
		/**
		 * 获取两点间的斜率
		 * @param	start 开始点坐标
		 * @param	end   结束点坐标
		 * @return
		 */
		public static function getSlope( start:Point, end:Point ):Number {
			
			return (end.x - start.x) / (start.y - end.y);
		}
		
		/**
		 * 获取两点间的斜度 
		 **/
		public static function getAngle( start:Point , end:Point ):Number {
			
			return Math.atan2( (end.x - start.x) , (start.y - end.y) );
		}
		
		/**
		 * 绘制法线
		 * @param   normalPoint 要对称的点
		 * @param	inster 与线条AB交点坐标
		 * @param	a 线条坐标A
		 * @param	b 线条坐标B
		 */
		public static function drawNormalLine(inster:Point, a:Point, b:Point, container:Sprite = null):void {
			
			//trace("绘制法线");
			//y = kx + c //法线方程			
			//var k:Number = ( a.y - b.y ) / ( a.x - b.x ); //ab线条斜度			
			var k:Number = (b.x - a.x) / (a.y - b.y); //法线斜度 k1 * k2 = -1;//垂线斜率			
			var c:Number = inster.y - k * inster.x;
			
			var p1:Point = new Point;
			var p2:Point = new Point;
			
			//Infinity 无穷大
			if (Math.abs(k) == Infinity) {
				
				p1.x = inster.x;
				p1.y = inster.y + 50;
				
				p2.x = inster.x;
				p2.y = inster.y - 50;
			} else {
				
				p1.x = inster.x + 50;
				p1.y = k * p1.x + c;
				
				p2.x = inster.x - 50;
				p2.y = k * p2.x + c;
			}
			
			if (container) {
				
				container.graphics.lineStyle(1, 0xffffff);
				container.graphics.moveTo(p1.x, p1.y);
				container.graphics.lineTo(p2.x, p2.y);
				container.graphics.lineStyle(1, 0x00ff00);
			}
		}
		
		/**
		 * 获取某点对应线条的对称点
		 * @param	point 要反射的点
		 * @param	lineA //线条垂线的两点
		 * @param	lineB
		 * @return
		 */
		public static function getSymmetricPoint(point:Point, lineA:Point, lineB:Point):Point {
			
			var k:Number;
			var c:Number;
			var x1:Number;
			var y1:Number;
			
			if (lineA.x == lineB.x) { //斜率为无穷时
				
				c = lineA.x;
				
				x1 = 2 * c - point.x; // lineA.x > point.x ? 2 * c - point.x : -( 2 * c + point.x );
				
				y1 = point.y;
				
				return new Point(x1, y1);
			} else if (lineA.y == lineB.y) { //斜率为0时对称点
				
				c = lineA.y;
				
				x1 = point.x;
				
				y1 = 2 * c - point.y; // lineA.y > point.y ? 2 * c - point.y : -( 2 * c + point.y );
				
				return new Point(x1, y1);
			}
			
			//线条 y = kx + c
			k = (lineA.y - lineB.y) / (lineA.x - lineB.x); //线条ab斜度		
			c = lineA.y - k * lineA.x;
			
			var x0:Number = point.x;
			var y0:Number = point.y;
			//ax + by + c = 0;
			var a:Number = k;
			var b:Number = -1;
			
			x1 = ((b * b - a * a) * x0 - 2 * a * b * y0 - 2 * a * c) / (a * a + b * b);
			y1 = ((a * a - b * b) * y0 - 2 * a * b * x0 - 2 * b * c) / (a * a + b * b);
			
			return new Point(x1, y1);
		}
		
		/**
		 * 获取点(x0,y0)到经过交点(insterPoint)线条的垂线ax + by + c = 0 的反射点(x1,y1)
		 * @param	point
		 * @param   insterPoint 交点
		 * @param	a
		 * @param	b
		 * @param	c
		 * @return
		 */
		private static function getSymmetricPointCrossLine(point:Point, insterPoint:Point, a:Number, b:Number, c:Number):Point {
			
			var x0:Number = point.x;
			var y0:Number = point.y;
			var x1:Number;
			var y1:Number;
			
			var k:Number = -a / b;
			
			if (Math.abs(k) == Infinity) { //穷大
				
				//problem
				x1 = 2 * insterPoint.x - x0; // -2 * c / a - x0;
				y1 = y0;
			} else if (k == 0) {
				
				x1 = x0;
				y1 = 2 * insterPoint.y - y0; // -2 * c / b - y0;
			} else {
				
				x1 = ((b * b - a * a) * x0 - 2 * a * b * y0 - 2 * a * c) / (a * a + b * b);
				y1 = ((a * a - b * b) * y0 - 2 * a * b * x0 - 2 * b * c) / (a * a + b * b);
			}
			
			return new Point(x1, y1);
		}
		
		/**
		 * 参考自http://hi.baidu.com/lzilun/item/65a441d213d13310d78ed09c
		 * 线段ab与cd的交点
		 * @param a
		 * @param b
		 * @param c
		 * @param d
		 * @return
		 *
		 */
		private static function getIntersection(a:Point, b:Point, c:Point, d:Point):Point {
			var intersection:Point = new Point(0, 0); //交点
			
			if (Math.abs(b.y - a.y) + Math.abs(b.x - a.x) + Math.abs(d.y - c.y) + Math.abs(d.x - c.x) == 0) {
				if ((c.x - a.x) + (c.y - a.y) == 0) {
					trace("ABCD是同一个点！");
				} else {
					trace("AB是一个点，CD是一个点，且AC不同！");
				}
				return null;
			}
			
			if (Math.abs(b.y - a.y) + Math.abs(b.x - a.x) == 0) {
				if ((a.x - d.x) * (c.y - d.y) - (a.y - d.y) * (c.x - d.x) == 0) {
					trace("A、B是一个点，且在CD线段上！");
				} else {
					trace("A、B是一个点，且不在CD线段上！");
				}
				return null;
			}
			if (Math.abs(d.y - c.y) + Math.abs(d.x - c.x) == 0) {
				if ((d.x - b.x) * (a.y - b.y) - (d.y - b.y) * (a.x - b.x) == 0) {
					trace("C、D是一个点，且在AB线段上！");
				} else {
					trace("C、D是一个点，且不在AB线段上！");
				}
				return null;
			}
			
			if ((b.y - a.y) * (c.x - d.x) - (b.x - a.x) * (c.y - d.y) == 0) {
				trace("线段平行，无交点！");
				return null;
			}
			
			intersection.x = ((b.x - a.x) * (c.x - d.x) * (c.y - a.y) - c.x * (b.x - a.x) * (c.y - d.y) + a.x * (b.y - a.y) * (c.x - d.x)) / ((b.y - a.y) * (c.x - d.x) - (b.x - a.x) * (c.y - d.y));
			intersection.y = ((b.y - a.y) * (c.y - d.y) * (c.x - a.x) - c.y * (b.y - a.y) * (c.x - d.x) + a.y * (b.x - a.x) * (c.y - d.y)) / ((b.x - a.x) * (c.y - d.y) - (b.y - a.y) * (c.x - d.x));
			
			if ( (intersection.x - a.x) * (intersection.x - b.x) <= 0 && (intersection.x - c.x) * (intersection.x - d.x) <= 0 && 
			     (intersection.y - a.y) * (intersection.y - b.y) <= 0 && (intersection.y - c.y) * (intersection.y - d.y) <= 0
				) {
				
				trace("线段相交于点(" + intersection.x + "," + intersection.y + ")！");
				return intersection; // '相交  
			} else {
				trace("线段相交于虚交点(" + intersection.x + "," + intersection.y + ")！");
				return null; // '相交但不在线段上  
			}
			
			return intersection;
		}
		
		/**
		 * 计算两点之间距离
		 * @param	point1
		 * @param	point2
		 * @return
		 */
		public static function getDistanceAt(point1:Point, point2:Point):Number {
			
			var dx:Number = point1.x - point2.x;
			var dy:Number = point1.y - point2.y;
			
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * http://bbs.9ria.com/thread-171055-1-1.html
		 * 获取物体从某点以某速度移动到目标点的抛物线轨迹
		 * 注意加速度应为负数;
		 * @param	speed 速度
		 * @param	g     重力加速度
		 * @param	bp    出生点
		 * @param	tp    目标点
		 * @return  弧度
		 */
		public function getAngleToPoint(speed:Number, g:Number, bp:Point, tp:Point):Number {
			//获得坐标差
			var dx:Number = tp.x - bp.x;
			var dy:Number = tp.y - bp.y;
			
			//tempV: 便于简化计算的一个临时变量
			var tempV:Number = g * dx / (2 * speed * speed)
			
			//根据一元二次方程会有两个解，对应一个角度较高和一个较低的两条抛物线，均可到达指定点
			//这里为了便于应用两个角度的解都给出，一般只计算减法解即可
			var ta1:Number = (1 + Math.sqrt(1 - 4 * tempV * (tempV + dy / dx))) / (2 * tempV);
			var ta2:Number = (1 - Math.sqrt(1 - 4 * tempV * (tempV + dy / dx))) / (2 * tempV);
			
			//超出射程范围时无解，故需要判断（这里只取了减法解）
			if (!ta2) {
				return NaN;
			} else {
				//由于是用原始的反正切函数，所以需要判断一下象限，注意所得到的为弧度
				return Math.atan(ta2);
			}
		}		
		
		/**
		 * 递归数组排列组合 2012.10.8 目前测试排到 [1,2,3,4,5,6]，长度超过此player运行超时，效率变低
		 * @param next 要排列的数组
		 * @param prev 初始为null
		 * @param out  最终输出数组
		 * @return 组合后的数组集合
		 *
		 */
		private function permutation(next:Array, prev:Array = null, out:Array = null):Array {
			if (next == null || (next.length <= 1)) {
				return next;
			}
			if (prev == null) {
				prev = [];
			}
			if (out == null) {
				out = [];
			}
			var j:uint = next.length;
			if (j == 1) {
				var t:Array = [];
				for (var i:uint = 0; i < prev.length; i++) {
					t.push(prev[i]);
				}
				t.push(next[0]);
				
				//出口及输出样式
				out.push(t.join("-"));
				return out;
			}
			for (var k:uint = 0; k < j; k++) {
				var p:Array = prev.slice();
				var s:Array = next.slice();
				p.push(s.splice(k, 1));
				permutation(s, p, out);
			}
			return out;
		}
		
		/**
		 * 求阶乘,递归算法 2012.10.7
		 * @param value 阶乘初始值(1~12),经测试flash超过12结果不准确
		 * @param out 最终输出结果,初始只能为1
		 * **/
		private function jiecheng(value:int, out:int = 1):int {
			if (value <= 0) {
				return 0;
			}
			if (value == 1) {
				return out;
			}
			out *= value;
			return jiecheng(--value, out);
		}
		
		/**
		 * 递归,如此0,1,1,2,3,5,8,13,21.....
		 * @param n 递归次数,目前测试递归不超过40次，20次内合适
		 * **/
		public function rusumeArray(n:int):int {
			if (n < 2) {
				return n;
			}
			return rusumeArray(n - 1) + rusumeArray(n - 2);
		}
		
		/**
		 * 获取最接近的2的倍数值
		 * @param	value	当前参数
		 * @param	max		最大倍数0~x
		 * @param  	type 	是否为当前值偏大或偏小值，0为默认距离最大或最小值接近的数值，1为接近当前值的最大值
		 * @return
		 */
		public static function getLast2Pow( value:int , max:uint = 12 , type:int = 0):int {
			
			var prev:int = 0;
			var val:int = 0;
			for ( var i:int = 0; i < max; i++ ) {				
				val = Math.pow( 2 , i );
				if ( value == val ) {
					return val;
				}
				
				if ( value < val ) {
					if ( type == 0  ) {
						if ( Math.abs( value - prev ) < Math.abs( value - val ) ) {
							return prev;
						}
						else {
							return val;
						}
					}
					else if ( type == -1 ) {
						return prev;
					}
					else if ( type == 1 ) {
						return val;
					}					
					break;
				}
				prev = val;
			}			
			return val;
		}
		
	}
}