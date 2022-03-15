import math
import strconv
#include "stdlib.h"
const (
	ndecimals = 6				// number of decimals to round
	ndecimals_visual = 3 		// number of decimals to round
	maxqbits = 10
)
struct Glob {
	mut:
	round_base			f64 = math.pow(10,ndecimals)
	round_base_visual	f64 = math.pow(10,ndecimals_visual)
	// aux for out data in console
	mchar				int = 120 	// max chars in a line to output console information
	charl 				byte = `*`
}
struct Cplx {
	mut:
	rv		f64 	// real value
	iv		f64		// imaginary value
	//glob	Glob
}
struct CCplx {
	mut:
	cplx		Cplx
}
// =============== Struct Global ======================
fn (glob Glob) round(n f64) f64 {
	return math.round(n * glob.round_base) / f64(glob.round_base)
}
fn (glob Glob) visual_round(n f64) f64 {
	return math.round(n * glob.round_base_visual) / f64(glob.round_base_visual)
}
// aux for out information to console
fn print1(lin string) {
	print2(0,lin)
}
fn print2(level int, lin string) {
	mut l := " >" + lin
	l = l.replace("\n", "\n  ")
	for i := 0; i < level; i++ {
		l = l.replace("\n", "\n  ")
		l = "  " + l
	}
	println(l)
}
fn (glob Glob) line1() { 			// writes a underline
	glob.line2(true)
}
fn (glob Glob) line2(jump bool) {
	if jump {
		println("\n" + glob.completeline("") + "\n")
	}else {
		println(glob.completeline(""))
	} 
}
fn (glob Glob) title(title string) { 
	mut tit := "" + glob.charl.ascii_str() + glob.charl.ascii_str() + " " + title + " "
	tit = glob.completeline(tit)
	println("")
 	glob.line2(false)
	println(tit)
	glob.line2(false)
}
fn (glob Glob) completeline(line string) string {
	mut lineret := line
	for lineret.len < glob.mchar {
		lineret = lineret + glob.charl.ascii_str()
	}
	return lineret
}
// ===================Struct Cplx ========================
// constructor
fn (mut c Cplx) cplx(rv f64, iv f64) {
	c.rv = rv
	c.iv = iv
	c.round()
}
// square modulus
fn (c Cplx) mod2() f64 {
	mut glob := Glob{}
	result := f64 ((math.pow(c.rv, 2) + math.pow(c.iv, 2)))
	return glob.round(result)
}
fn (mut c Cplx) round() {
	mut glob := Glob{}
	c.rv = glob.round(c.rv)
	c.iv = glob.round(c.iv)
}
// modulus
fn (c Cplx) mod() f64 {
	return f64(math.sqrt(c.mod2()))
}

fn (c Cplx) isnotzero() bool {
	return !c.iszero()
}
fn (c Cplx) iszero() bool {
	return c.rv == 0 && c.iv == 0
}
fn (mut c Cplx) tostr() string {
	return c.to_str(false)
}
fn (mut c Cplx) to_str(forcelong bool) string {
	mut glob := Glob{}
	rv_ := glob.visual_round(c.rv)
	iv_ := glob.visual_round(c.iv)
	
	mut s := if rv_ >= 0 { "( " } else { "(" }		 // negative sign or space
	if c.iv >= 0 {
		s += strconv.f64_to_str(rv_,2) + " + " + strconv.f64_to_str(iv_,2) + "i " + ")"
	} else {
		s += strconv.f64_to_str(rv_,2) + " - " + strconv.f64_to_str(-iv_,2) + "i " + ")"
	}
	if !forcelong {
		if rv_ != 0 && iv_ == 0 {
			if rv_ >= 0 {
				s = " " + strconv.f64_to_str(rv_,2) + ""
			} else {
				s = strconv.f64_to_str(rv_,2) + ""
			}
		} else if iv_ != 0 && rv_ == 0 {
			if iv_ >= 0 {
				s = " " + strconv.f64_to_str(iv_,2) + "i"
			} else {
				s = strconv.f64_to_str(iv_,2) + "i"
			}
		} else if iv_ == 0 && rv_ == 0 {
			s = " 0.0"
		}
	}
	return s
}
// ===================Struct CCplx ========================
fn add(c1 Cplx, c2 Cplx) Cplx {
	mut res := Cplx{0, 0}
	res.rv = c1.rv + c2.rv
	res.iv = c1.iv + c2.iv
	res.round()
	return res
}
fn (mut cc CCplx) mul(c1 Cplx, c2 Cplx) Cplx {
	mut res := Cplx{0, 0}
	res.rv = c1.rv * c2.rv - c1.iv * c2.iv
	res.iv = c1.rv * c2.iv + c1.iv * c2.rv
	res.round()
	return res
}
fn eq(c1 Cplx,c2 Cplx) bool {
	return c1.rv == c2.rv && c1.iv == c2.iv
}
// ===================Struct Bin ========================
struct Bin {
	mut:
	groups		[]int = []int{len:1}
						// groups of bits. p.e. 2, 3, 8 --> 
	                  	//   --> data: 1011101101010 --> 10 111 01101010 
	                  	//      (2, 3 and 8 bits)
	
	bindata		[]int = []int{len:maxqbits, init: 0}	// Less weight bit is bindata[0]
	indmax		int = -1 								// how many
}
// constructors
fn (mut bin Bin) bin1(n int) {
	bin.constructor(n, 0)
}
fn (mut bin Bin) bin2(n int, max_bits int) {
	bin.constructor(n, max_bits)
}
fn (mut bin Bin) constructor(base10_number int, how_many_bits int) {  // 0 to 2 ^ how_many_bits - 1  
	//bin.groups[0] = 0
	mut num := base10_number
	for ind := 0; num > 0; ind++ {
		mod := int(num % 2)
		num = int(num / 2)
		bin.bindata[ind] = mod
		bin.indmax++
	}
	if how_many_bits - 1 > bin.indmax {
		bin.indmax = how_many_bits - 1
	}
}
fn (mut bin Bin) getbit(bit int) int {
	if bit > bin.indmax {
		return 0
	}
	return bin.bindata[bit]
}
fn (mut bin Bin) delbit(bit int) {  // 0 to n - 1
	// change  p.e.   1000101  delBit(1) --> 100011  (deleted the second bit)   
	for i := bit; i < bin.indmax; i++ {
		bin.bindata[ i ] = bin.bindata[ i + 1 ]
	}
	bin.bindata[ bin.indmax ] = 0
	bin.indmax -= 1
}
fn (mut bin Bin) clone() Bin {
	mut ret := Bin{}
	ret.bindata = bin.bindata
	ret.groups = bin.groups	
	ret.indmax = bin.indmax
	return ret
}
fn (mut bin Bin) setgroups(groups []int)  {
	mut sumbits := 0
	for i := 0; i < groups.len; i++ {
		sumbits += groups[i]
	}
	if sumbits == bin.indmax + 1 {
		bin.groups = groups
	} 
}
fn (mut bin Bin) swap(bit1 int, bit2 int) {
	data := bin.bindata[bit1]
	bin.bindata[bit1] = bin.bindata[bit2]
	bin.bindata[bit2] = data
	if bit1 > bin.indmax {
		bin.indmax = bit1
	}
	if bit2 > bin.indmax {
		bin.indmax = bit2
	}
}
fn (mut bin Bin) tostr() string {
	mut ret := ""
	mut withgroups := bin.groups.len > 0
	
	mut indexgroup := 0
	mut maxgroup := 0
	if withgroups {
		maxgroup = bin.groups[indexgroup]
		indexgroup++
	}
	for i := bin.indmax; i >= 0; i-- {
		ret = ret + bin.bindata[i].str()
		if withgroups {
			maxgroup--
			if maxgroup == 0 && i > 0 {
				ret = ret + " "
				maxgroup = bin.groups[indexgroup]
				indexgroup++
			}
		}
	}
	return ret
}
fn (mut bin Bin) toint() int {
	mut n := 0
	for index := bin.indmax; index >= 0; index-- {
		n = n + int(math.pow(2, index)) * bin.bindata[index]
	}
	return n
}
// ===================Struct Matrix ======================
struct Matrix {
	mut:
	// --- core data -----
	matrix			map[int]Cplx
	maxrow			int
	maxcol			int
}
// converts row-col values into index
fn getkey(row int, col int) int {
	return row * maxqbits + col
}
// inverse of getKey . returns row and col given 'key'.
fn getrowcol(key int) []int {
	mut rowcol := []int{len:2}
	rowcol[0] = int(math.floor(key/maxqbits))
	rowcol[1] = int(key % maxqbits)
	//println(rowcol)
	return rowcol
}
// if row is greater than maxrow, then assign new value 'row'
// if col is greater than maxcol, then assign new value 'col'
fn (mut this Matrix) recalc_dim(row int, col int) {
	if row > this.maxrow {
		this.maxrow = row
	}
	if col > this.maxcol {
		this.maxcol = col
	}
}
// reads the value in row-col
fn (mut this Matrix) get(row int , col int) Cplx {
	mut null := Cplx{}
	mut zero := Cplx{0,0}
	key := getkey(row, col)
	v := this.matrix[key]
	return if v != null { v } else { zero }
}
// deletes the value in row-col
fn (mut this Matrix) del(row int, col int) {
	key := getkey(row, col)
	this.matrix.delete(key)
}
// adds a new value in row - col position. If already exists, overwrites it
// adding a zero value means delete the data in that position
fn (mut this Matrix) put(row int, col int, value Cplx) {
	if value.iszero() {
		this.del(row, col)
		return
	}
	key := getkey(row, col)
	this.matrix[key] = value
	this.recalc_dim(row, col)
}
// adds a one (as complex number) in row-col position. If already exists a
// value, overwrites it
fn (mut this Matrix) put_one(row int, col int) {
	one := Cplx{1, 0}
	this.put(row, col, one)
}
// adds passed value to existing value
fn (mut this Matrix) add(row int, col int, value_to_add Cplx) {
	key := getkey(row, col)
	mut null := Cplx{}
	mut finalvalue := Cplx{}
	initialvalue := this.matrix[key]
	if initialvalue != null { 
		finalvalue = add(initialvalue, value_to_add) 
	}else { 
		finalvalue = value_to_add 
	}
	this.put(row, col, finalvalue)
}
// adds one (as complex number) to exixting value
fn (mut this Matrix) add_one(row int, col int) {
	one := Cplx{1, 0}
	this.add(row, col, one)
}
// close values to another matrix
fn (mut this Matrix) clone() Matrix {
	mut m := Matrix{}
	m.matrix = this.matrix.clone()
	m.maxrow = this.maxrow
	m.maxcol = this.maxcol
	return m
}
// convert data to string to be shown on screen console
// it can be internally unsorted, so must be red in ascendent order
fn (mut this Matrix) tostr() string { 
	mut st := []string{len:1}
	mut keys := this.matrix.keys()
	keys.sort()
	//println(keys)
	for index in keys {
		mut rowcol := []int{len:10}
		rowcol = getrowcol(index)
		//println(rowcol)
		//println(this.matrix[index])
		st[0] = st[0] + " Row: " + rowcol[0].str() + " Col: " + 
				rowcol[1].str() + " -> " + this.matrix[index].tostr() + "\n"
		//println(st)
	}
	return st[0]
}
// show matrix data on console
fn (mut this Matrix) printm1() {
	this.printm2(0)
}
fn (mut this Matrix) printm2(level int) {
	print2(level, this.tostr())
}
// ===================Struct CMatrix ======================
struct CMatrix {
	mut:
	cmatrix			Matrix
}
// multiplies two matrix
fn (mut cmatrix CMatrix) mul(m1 Matrix, m2 Matrix) Matrix {
	mut mat := Matrix{}
	if m1.maxcol != m2.maxrow {
		return mat
	}
	for index1,c1 in m1.matrix {
		mut rowcol1 := getrowcol(index1)
		mut row1 := rowcol1[0]
		mut col1 := rowcol1[1]
		for index2, c2 in m2.matrix {
			mut rowcol2 := getrowcol(index2)
			mut row2 := rowcol2[0]
			mut col2 := rowcol2[1]
			if col1 == row2 { // must multiply
				mut ccplx := CCplx{}
				mat.add(row1, col2, ccplx.mul(c1, c2))
			}
		}
	}
	mat.maxrow = m1.maxrow
	mat.maxcol = m2.maxcol
	return mat
}
// kroneker product 
fn kroneker(m1 Matrix, m2 Matrix) Matrix {
	mut result := Matrix{}
	for index1, d1 in m1.matrix {
		rowcol1 := getrowcol(index1)
		row1 := rowcol1[0]
		col1 := rowcol1[1]
		for index2, d2 in m2.matrix {
			mut rowcol2 := getrowcol(index2)
			row2 := rowcol2[0]
			col2 := rowcol2[1]
			mut resrow := row1 * (m2.maxrow + 1) + row2
			mut rescol := col1 * (m2.maxcol + 1) + col2
			mut ccplx := CCplx{}
			resdata := ccplx.mul(d1, d2)
			result.add(resrow, rescol, resdata)
		}
	}
	result.maxrow = (m1.maxrow + 1) * (m2.maxrow + 1) - 1
	result.maxcol = (m1.maxcol + 1) * (m2.maxcol + 1) - 1
	return result
}
// kroneker product of several matrix
fn kroneker_(mut ops []Matrix) Matrix {
	mut result := Matrix{}
	if ops.len == 0 {
		return result
	}
	result = ops[0].clone()
	for ind := 1; ind < ops.len; ind++ {
		result = kroneker(result, ops[ind])
	}
	return result
}
// ===================Struct Vector ======================
struct Vector {
	mut:
	matriz		Matrix
}
// parameter 'm' must be a real vector, but in form of matrix type (p.e. as a
// result of product of matrix )
fn (mut this Vector) getfrommatrix(m Matrix) {
	// change core data
	this.matriz.matrix = m.matrix.clone()
	this.matriz.maxcol = 0
	this.matriz.maxrow = m.maxrow
}
// new vector functions always with col = 0
fn (mut this Vector) add(row int, value Cplx) {
	this.matriz.add(row, 0, value)
}
fn (mut this Vector) put(row int, value Cplx) {
	this.matriz.put(row, 0, value)
}
fn (mut this Vector) put_one(row int) {
	this.matriz.put_one(row, 0)
}
fn (mut this Vector) add_one(row int) {
	this.matriz.add_one(row, 0)
}
fn (mut this Vector) del(row int) {
	this.matriz.del(row, 0)
}
fn (mut this Vector) get(row int) Cplx {
	return this.matriz.get(row, 0)
}
// ===================Struct QGATE ======================
struct QGate {
	mut:
	matriz		Matrix
	u			Matrix
	x			Matrix
	h 			Matrix
	cnot 		Matrix
}
fn (mut qgate QGate) u_gate() {
	// U  Gate
	//   1  0
	//   0  1
	//U = new QGate()
	qgate.u.add_one(0, 0)
	qgate.u.add_one(1, 1)
}
fn (mut qgate QGate) x_gate() {
	// X  Gate
	//   0  1
	//   1  0
	//X = new QGate();
 	qgate.x.add_one(0, 1)
	qgate.x.add_one(1, 0)
}
fn (mut qgate QGate) h_gate() {
	// H  Gate:  1 / sqr(2)
	//   1  1
	//   1 -1
	//H = new QGate();
	sq2 := f64 (1 / math.sqrt(2))
	qgate.h.add(0,0, Cplx{sq2,0})
	qgate.h.add(0,1, Cplx{sq2,0})
	qgate.h.add(1,0, Cplx{sq2,0})
	qgate.h.add(1,1, Cplx{-sq2,0})	
}
fn (mut qgate QGate) cnot_gate() { 
	// CNOT Gate
	//   1  0  0  0
	//   0  1  0  0
	//   0  0  0  1
	//   0  0  1  0
	//CNOT = new QGate();
	qgate.cnot.add_one(0, 0)
	qgate.cnot.add_one(1, 1)
	qgate.cnot.add_one(2, 3)
	qgate.cnot.add_one(3, 2)
}
fn (mut qgate QGate) getfrommatrix(m Matrix) {
	// change core data
 	qgate.matriz.matrix = m.matrix.clone()
	qgate.matriz.maxrow = m.maxrow
	qgate.matriz.maxcol = m.maxcol
}
// ===================Struct State ======================
struct State {
	mut:
	vector			Vector
	qgate			QGate
	nqbits			int
	measures		map[int]int
	one				Cplx = Cplx{1,0}
	rand			f64 = 0.09
}
// by default its like an scalar. Just one element (0,0) = 1.
fn (mut this State) state() {
	this.vector.add(0,this.one)
}
fn (mut this State) qb_zero() State {
	mut qb_zero := State{}
	qb_zero.state()    				// base state with just one element: (0,0) = Cplx.one
	qb_zero.vector.matriz.maxrow = 1      	// must redimensioning
	return qb_zero
}
fn (mut this State) qb_one() State {
	mut qb_one := State{}     // base state with just one element: (0,0) = Cplx.one
	qb_one.vector.del(0)            // must delete. created on constructor 
	qb_one.vector.put(1, this.one)  // implicit redimensioning
	return qb_one
}
// adds a qubit |0> to state (with kroneker operation). 
// Updates itself to new state.
fn (mut this State) add_qubit() {
	//println(this.qb_zero())
	this.vector.getfrommatrix(kroneker(this.vector.matriz, this.qb_zero().vector.matriz))
	this.nqbits += 1
}
// redefinition of toStr. We want to show probability of each element of state
fn (mut this State) tostr() string {
	mut prob := []f64{len:1,init: 0}
	mut st := []string{len:1,init:""}
	println(this.vector.matriz.matrix)
	for i, mut data in this.vector.matriz.matrix {
		mod2 := data.mod2()
		prob[0] += mod2
		rowcol := getrowcol(i)
		st[0] = st[0] + " Row: " + rowcol[0].str() + " -> " + data.tostr() + " prob: " + mod2.str() + "\n"
	}
	st[0] = st[0] + " Total prob = " + prob[0].str() + "\n"

	return st[0]
}
fn (mut this State) printst() {
	println(this.tostr())
}
// make 'n' measurements to the state. In a real Q computer, a measurement
// destroys the qubit
fn (mut this State) measure(quant int) ?string {
	//this.measures.clear()
	mut s := ""
	mut keys := this.vector.matriz.matrix.keys()
	keys.sort()
	//println(keys)
	for lap := 1; lap <= quant; lap++ {
		current_prob := f64(C.rand()) / f64(C.RAND_MAX)		// current probability measured: 0<= p < 1
		mut accum_prob := 0.0								// accumulated probability
		for index in keys {
			//println(index)
			mut measure := 0
			accum_prob += this.vector.get(index).mod2()
			if accum_prob > current_prob { 		// this is the state measured
					measure = this.measures[index]  or { 
														measure = 1 
														continue 
														}
					measure += 1
				//this.measures.put(index, measure)
				this.measures[index] = measure
				continue
			}
		}

	}
	// out to console
	s = " --- Measures ----------------- q = " + quant.str() + " \n"
	println(this.measures)
	mut measures_keys := this.measures.keys()
	measures_keys.sort()
	println(measures_keys)
	for measures_index in measures_keys {
		q := this.measures[measures_index]
		row := measures_index / maxqbits
		mut bin := Bin{}
		bin.bin2(row, this.nqbits)
		s = s + " " + bin.tostr() + " -> " + q.str() + " - " + 
			(math.round((f64(q)) / (f64(quant)) * 1000) / 10).str() +
			" %" + " \n"
	}
	s = s + " ------------------------------ \n"
	return s
}
// applies a matrix to state (multiplies the matrix by self vector and updates
// itself with new state
fn (mut this State) apply(m Matrix) {
	mut cmatrix := CMatrix{}
	//println(m)
	//println(this.vector.matriz)
	//println(cmatrix.mul(m, this.vector.matriz))
	this.vector.getfrommatrix(cmatrix.mul(m, this.vector.matriz)) // assigns result of product (it's a matrix) to self vector.
}
// adds 'n' qubits |0> to the state (with kroneker operation). Updates itself to
// new state.
fn (mut this State) add_qubits(q int) {
	for i := 1; i <= q; i++ {
		this.add_qubit()
	}
}
fn main() {
	mut glob := Glob{}
	glob.title(" 1 qbit state |0> ")
	mut st_qb := State{Vector{},QGate{},0,{0:0},Cplx{1,0},0.09}
	st_qb.state()
	st_qb.add_qubit() // adds a new qubit |0> to the empty state --> result: (1,0) state
	/*st_qb.printst()
	print1(st_qb.measure(1000)?)

	glob.title("applies U gate --> must remain the same")
	st_qb.measures = {0:0}
	//mut u := QGate{}
	st_qb.qgate.u_gate()
	//u.u_gate()
	st_qb.apply(st_qb.qgate.u)
	st_qb.printst()
	print1(st_qb.measure(1000)?)

	glob.title("applies X gate --> must change to (0, 1) that is |1>")
	//st_qb.measures = {0:0}
	//mut x := QGate{}
	//x.x_gate()
	st_qb.qgate.x_gate()
	st_qb.apply(st_qb.qgate.x)
	st_qb.printst()
	print2(1, st_qb.measure(1000)?)

	glob.title("applies X gate again --> must change to (1, 0)  that is |0> ")
	st_qb.measures = {0:0}
	st_qb.apply(st_qb.qgate.x)
	//st_qb.vector.matriz.printm2(1)
	st_qb.printst()
	print1(st_qb.measure(1000)?)
*/
	glob.title(" applies H gate --> in superposition ! --> 1 / sqr(2) (1, 1)")
	st_qb.measures = {0:0}
	//st_qb.state()
	mut h := QGate{}
	h.h_gate()
	st_qb.apply(h.h)
	st_qb.printst()
	//st_qb.vector.matriz.printm2(1)
	print1(st_qb.measure(1000)?)

	println('test')
}
fn pseudorandom(seed f64, a int, c int, m f64) f64 {
	mut s := seed
  	s = math.fmod((a * s + c) , m)  
  	return s / m + 0.09
}