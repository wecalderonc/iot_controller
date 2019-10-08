

const period = 1
let start_date = new Date(2019,0,1)
let end_date = new Date(2019,09,3)

let new_date = new Date(start_date)
console.log(new_date)
let re = 0

function recursivo(new_date, end_date, period) {
  if (new_date > end_date) {
        return re;
    } else {
        re = new Date(new_date)
        new_date = new Date(new_date.setMonth(new_date.getMonth() + period))
        return recursivo(new_date, end_date, period);
    }
}

console.log("recurisvo")
let recursivo2 = recursivo(new_date, end_date, period)
console.log(recursivo2)
