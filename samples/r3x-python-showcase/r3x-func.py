import r3x
import json

def r3xFunc(input):
    i = json.loads(input)
    for key,value in i.items():
        if str(key) == "name":
            res = {"message": "hello {}".format(value)}
        else:
            res = {"message" : "hello r3x"}
    json_res = json.dumps(res)
    return json_res

if __name__ == "__main__":  
    r3x.execute(r3xFunc)