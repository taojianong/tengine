package com.tloader.model {
	
	import com.log.TLog;
	import com.tloader.TSourceManager;
	
	/**
	 * 空闲资源加载器,继承异步资源加载器
	 * @author taojianlong 2014-6-7 22:41
	 */
	public class TFreeLoader extends TAsynchroLoader {
		
		public function TFreeLoader( sourceList:Vector.<TSource>=null ) {
			
			super( sourceList );
		}
		
		override public function add( source:TSource ):void {
			
			if ( source == null ) {
				TLog.addLog("添加资源不能为空！");
				return;
			}
			
			if ( !source.isFreeLoad ) { //非空闲加载资源				
				
				TLog.addLog( "添加资源非空闲加载资源到[空闲加载器]中！" , TLog.LOG_ERROR );
				return;
			}
			
			if ( hasTSource( source ) ) {
				
				TLog.addLog("资源已在空闲加载器列表中！");
				return;
			}
			
			if ( TSourceManager.hasCache( source.id ) ) {
				
				TLog.addLog("资源已缓存！");
				return;
			}
			
			_sourceList = _sourceList || new Vector.<TSource>;
			
			_sourceList.push( source );			
			
			TLog.addLog("添加资源 id: " + source.id + " url: " + source.url + "到[空闲加载器]中。" );
			
			//空闲加载器让它来一个加载一个
			total++;
			loadSingle( source );	
		}
	}

}