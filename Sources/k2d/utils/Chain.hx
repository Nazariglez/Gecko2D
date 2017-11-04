package k2d.utils;

class Chain {
    @:generic static public function each<T>(arr:Array<T>, cb:T->(?String->Void)->Void, done:?String -> Void){
        var count = 0;
        var canceled = false;

        for(i in 0...arr.length){
            if(canceled){
                break;
            }

            cb(arr[i], function(?err:String){
                if(canceled){ return; }
                
                if(err != null && err != ""){
                    canceled = true;
                    done(err);
                    return;
                }

                count++;

                if(count == arr.length){
                    done();
                }
            });
        }
    }

    @:generic static public function eachSeries<T>(arr:Array<T>, cb:T->(?String->Void)->Void, done:?String -> Void){
        var callback = function(){
            done();
        };

        var copyArr = arr.copy();
        copyArr.reverse();
        for(i in 0...copyArr.length){
            callback = function(element, _callback){
				return function(){
                    cb(element, function(?err:String){
                        if(err != null){
                            done(err);
                            return;
                        }

                        _callback();
                    });
                }
            }(copyArr[i], callback);
        }

        callback();
    }

    @:generic static public function eachLimit<T>(limit:Int, arr:Array<T>, cb:T->(?String->Void)->Void, done:?String -> Void){
        //todo
    }
}