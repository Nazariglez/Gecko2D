package k2d;

class Async {
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
}