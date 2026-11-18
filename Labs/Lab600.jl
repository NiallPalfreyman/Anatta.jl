#========================================================================================#
#	Laboratory 600: Introduction to Quantum Computation
#
# Author: Niall Palfreyman, 24/04/2022
#========================================================================================#
[
    Activity(
        """
        Hi! Welcome to Anatta Subject 600:
            Quantum computing - Small stories generate large structures
        
        In this course we explore the wonderful world of quantum physics, quantum computing and
        quantum information. In this introductory lab, we first gather the various mathematical
        tools we need for dealing with quantum systems. In particular, we will need to increase
        our knowledge of Julia to include complex numbers and matrices!

        You might be asking yourself: Why do we need complex numbers? The answer is that quantum
        particles possess certain wave properties that can interfere with each other, and the
        easiest way to calculate these interferences is by using complex numbers. So let's start...

        Remember that a complex number z has the general form x+iy, where x and y are real numbers,
        and i^2==-1. Check this now: In Julia, the number i is written "im", so tell me the
        value of
            im^2
        """,
        "Notice the way in which Julia writes this number - does it make sense to you?",
        x -> x == -1
    ),
    Activity(
        """
        Any complex number has a Real part x and an Imaginary part y. Form the following two
        complex numbers and tell me their sum:
            z1 = 4+5im
            z2 = 3-5im
            z1 + z2
        """,
        "",
        x -> x == 7
    ),
    Activity(
        """
        What is the value of the difference z1 - z2?
        """,
        "",
        x -> x == 1+10im
    ),
    Activity(
        """
        We calculate the Conjugate of a complex number by simply reversing the sign of its
        imaginary part. Calculate the complex conjugate of 5+2im:
            conj(5+2im)
        """,
        "",
        x -> x == 5-2im
    ),
    Activity(
        """
        We can also use the operator ' to take the conjugate of a complex number. Calculate
        the value of the complex conjugate of z1:
            z1'

        """,
        "",
        x -> x == 4-5im
    ),
    Activity(
        """
        The conjugate of a product of complex numbers is equal to the product of their
        individual conjugates. Check that this is true:
            (z1*z2)' == a1' * z2'
        """,
        "",
        x -> x == true
    ),
    Activity(
        """
        If we think of a complex number as a vector in the Gaussian plane, its real part is
        its coordinate along the horizontal real axis, and its imaginary part is its coordinate
        along the vertical imaginary axis. In this case, we can calculate the Norm of a complex
        number by using Pythagoras: We square its real and imaginary parts, add them together,
        then take the square-root of the result. Check that this is true by using the Julia
        function abs():
            abs(z1)^2 == real(z1)^2 + imag(z1)^2
        """,
        "",
        x -> x == true
    ),
    Activity(
        """
        We can also compute the norm of a complex number by multiplying the number by its
        conjugate and taking its square-root. Check that this is correct:
            a = abs(z2)
            b = sqrt(z2 * conj(z2))
            a == b
        """,
        "",
        x -> x == true
    ),
    Activity(
        """
        We calculate complex exponents using Euler's famous formula:
            θ = 3
            a = exp(θ*im)
            b = cos(θ) + sin(θ)*im
            a == b
        """,
        "",
        x -> x == true
    ),
    Activity(
        """
        In general, we can express any complex number as the product of its norm and a complex
        exponentiation:
            abs(z1) * exp(angle(z1)*im)

        If you calculate this value, you will see that rounding errors make it not quite equal to
        z1, but it is very close. Approximately how big is the absolute magnitude of the difference
        between these two complex numbers?
        """,
        "Notice we are asking whether z1 == abs(z1) * exp(angle(z1)*im)",
        x -> x < 1e-15
    ),
    Activity(
        """
        In classical computing, the state of a bit in computer memory can only have ONE value:
        Either 0 Or 1 (but not both!). The very crucial difference in quantum computing is that
        the state of a bit in a quantum computer memory can Simultaneiously have the two different
        values 0 and 1 with certain probabilities. We call this probabilistic state of a quantum
        bit a Qubit.
        
        We think of a qubit as an N-dimensional column vector of complex numbers, where N is
        usually a power of 2. We call such a column vector a Ket, written mathematically as "|x>".
        In Julia, we will use small letters to identify kets, for example:
            x = [-1, 2im,  1]

        Use Julia to calculate the norm of the ket x by squaring the absolute value of each
        complex component, adding these together, then taking the square root:
        """,
        "sqrt(sum(abs.(x).^2))",
        x -> 2.44 < x < 2.45
    ),
    Activity(
        """
        We know how to use ' to calculate the conjugate of a complex number; now we will see that
        this operator has a more general purpose. Use Julia to check that the size of x is (3,1),
        then find the size of x' :
        """,
        "size(x')",
        x -> x == (1,3)
    ),
    Activity(
        """
        x' is the Adjoint of x; we calculate it by transposing x (i.e., swapping rows and columns),
        then taking the complex conjugate of each element of x. We can calculate the adjoint of
        any matrix. What is the adjoint of the following matrix?
            M = [
                1+4im 2-3im -2+im
                2-5im 2+3im    5
                  2     3    3-5im
            ]
        """,
        "",
        x -> x == [1-4im  2+5im  2+0im; 2+3im  2-3im  3+0im; -2-1im  5+0im  3+5im]
    ),
    Activity(
        """
        We call a row vector of complex numbers a Bra, written mathematically as "<x|". In Julia,
        we will use small letters followed by a bang (!) to identify bras, for example:
            y! = [ 1,   0, im]'

        Use Julia to calculate the norm of the bra y! by squaring the absolute value of each
        complex component, adding these together, then taking the square root:
        """,
        "sqrt(sum(abs.(y!).^2))",
        x -> 1.41 < x < 1.42
    ),
    Activity(
        """
        We can use the adjoint operation to turn a ket into a bra or to turn a bra into a ket.
        Look at the values of x and x', and check that they are respectively a ket and a bra:
            x
            x'
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Verify that taking the adjoint twice returns us to the original ket:
            x'' == x
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Verify that taking the adjoint twice returns us to the original bra:
            y!'' == y!
        """,
        "",
        x -> true
    ),
    Activity(
        """
        We calculate the Inner product (also called the dot product) by matrix-multiplying a
        bra and a ket: <y|.|x> = <y||x> = <y|x> . Paul Dirac suggested the names bra and ket
        because together they form the BRAcKETs <y|x> that we use to calculate probabilities
        in quantum theory. Calculate the following inner product:
            y! * x
        """,
        "",
        x -> x == -1-im
    ),
    Activity(
        """
        Verify experimentally that <y|x> is not the same as <x|y>:
            y!*x != x' * y!'
        """,
        "",
        x -> true
    ),
    Activity(
        """
        Use experiments to find out, is the following rule correct: <x|y>' == <y|x> ?
        """,
        "This rule is indeed correct - can you verify it using x and y (= y!')?",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        Two non-zero vectors are Orthogonal if their inner product is zero. For example,
        define the following vector:
            z = [1,im,-1]

        then verify that z is orthogonal to x:
            <z|x> == <x|z> == 0
        """,
        "z'*x == x'*z == 0"
    ),
    Activity(
        """
        If two real-valued vectors a and b are orthogonal to each other, they always stand at an
        right-angles to each other. For example, plot the following two real-valued vectors to
        convince yourself that the angle between them is a right-angle, then use the inner product
        to verify that they are also orthogonal:
            a = [1,1]
            b = [-1,1]
        """,
        "a'*b == b'*a == 0"
    ),
    Activity(
        """
        If the inner product of a bra or ket with itself is equal to 1.0, we say that the vector is
        Normalised (that is, it has unit length). In quantum computing, a qubit is a state vector:
        it represents the probability that a quantum bit is in the state 0 or 1. Of course, since
        this quantum bit can Only be in one of these two states, the sum of their probabilities
        must equal 1. Because of this, we always use normalised vectors to represent qubits.

        Verify that this ket is normalised:
            n = [0.6,0.8im]
        """,
        "<n|n> == n'*n == 1.0",
        x -> true
    ),
    Activity(
        """
        We form the OUTER product of two vectors by matrix-multiplying a ket and a bra:
            |x><y| = x*y!

        Notice: We calculate an Inner product as (bra*ket), but we calculate the Outer product
        as (ket*bra). The size of our ket x is (3,1), and the size of our bra y! is (1,3). What
        will be the size of the outer product x*y! ?
        """,
        "Remember the rules for multiplying matrices!",
        x -> x == (3,3)
    ),
    Activity(
        """
        What is the value of the outer product matrix |x><y| ?
        """,
        "x*y!",
        x -> x == [-1  0  im; 2im  0  2; 1  0  -im]
    ),
    Activity(
        """
        A square matrix A is Hermitian if A is equal to its own adjoint:
            A == A'

        Verify that the following matrix is Hermitian:
            A = [
                1		3+2im
                3-2im	0
            ]
        """
    ),
    Activity(
        """
        The special point about Hermitian matrices is that their eigenvalues are always real
        numbers. In quantum theory, eigenvalues are the values that we can measure in physical
        experiments, so it makes sense that we want these to be real numbers. Consequently,
        Hermitian matrices represent physical measurements like: "Is this qubit equal to 1?"

        Is this matrix Hermitian?
            B = [
                -5			99-5im
                99+5im		2
            ]
        """,
        "Remember: Transpose B, then take the complex conjugate",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        A matrix U is Unitary if the adjoint of U is equal to its own inverse:
            U * U' == U' * U == I

        (where I is the identity matrix). Is the following matrix U unitary?
            U = [0 im;-im 0]
        """,
        "Test whether U'*U==I, and whether U*U'==I",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        Did you notice that U is not only unitary, but also Hermitian? Verify this now.
        """
    ),
    Activity(
        """
        The special point about unitary matrices is that they do not change the norm of a vector.
        They are like rotations in a complex vector space that change the direction of the
        vector, but not its length. We will see that this is important for describing how a qubit
        changes over time. Is the following matrix S unitary?
            S = [1 0;0 exp(im)]
        """,
        "",
        x -> occursin('y',lowercase(x))
    ),
    Activity(
        """
        Is the matrix X Hermitian?
        """,
        "",
        x -> occursin('n',lowercase(x))
    ),
    Activity(
        """
        To summarise our findings so far, forming the adjoint turns kets into bras, turns bras into
        kets, and reverses the order of multiplications:
            x! = x'
            y  = y!'
            <y|x>' == <x|y>
            (|x><y|)' == |y>'<x|'
            (A * x)' == x' * A'
            (A * S)' == S' * A'

        Verify each of these rules now ...
        """,
        "Remember that <x|y> simply means x'*y"
    ),
    Activity(
        """
        In general, multiplying a matrix M with a ket x will change the direction of x; however,
        there is often a special set of kets |ψ> (the Eigenvectors of M) and complex numbers λ (the
        Eigenvalues), for which the following equation applies:
            M |ψ> == λ |ψ>

        That is, M only changes the magnitude of |ψ> (multiplies it by λ), but doesn't change the
        direction of |ψ>. For example, here is one of the famous Pauli spin matrices:
            S_y = [0 -im;im 0]

        Verify that the vector
            ψ_yp = [1,im]
        
        is an eigenvector of S_y, and tell me the corresponding eigenvalue:
        """,
        "Remember, we require: S_y ψ_yp == λ ψ_yp",
        x -> x == 1
    ),
    Activity(
        """
        Now verify that ψ_ym = [1,-im] is also an eigenvector of S_y, and tell me the corresponding
        eigenvalue:
        """,
        "",
        x -> x == -1
    ),
    Activity(
        """
        To end this mathematical introduction, let me remind you that the Trace of a matrix A is
        sum of the elements along its leading diagonal. What is the trace of the following matrix?
            M = [1 2;3 4]
        """,
        "",
        x -> x == 5
    ),
    Activity(
        """
        The special point about the trace of a matrix is that the trace of an outer product is
        equal to the corresponding inner product. Let's verify this using the two Pauli spin
        eigenkets ψ_yp and ψ_ym. Suppose x is one of these two kets, and y is again either of
        the two (y might even be the same as x), then we can combine these two kets either as an
        inner or an outer product:
            <x|y> == (x' * y) , or
            |x><y| == (x * y')

        The first of these expressions is a number - the Inner product of x and y - while the
        second expression is a matrix - the Outer product of x and y. Now take the trace of the
        outer product - is it equal to the inner product?
        """,
        "",
        x -> x == occursin('y',lowercase(x))
    ),
    Activity(
        """
        Sometimes during this course, we will want to use special matrix functions that are not
        built into Julia. In such cases, we will load the LinearAlgebra package, which contains
        many useful matrix functions. For example, LinearAlgebra contains a function for
        calculating the trace of a matrix: tr(M). Use this function to repeat the previous two
        exercises, calculating the trace of M and verifying that the trace of the outer product
        of ψ_yp and ψ_ym is equal to their inner product.
        """
    ),
    Activity(
        """
        OK, now we have all the mathematical apparatus we need to get started with quantum
        computation! The first thing we will do in the following lab is to build Our Very
        Own Quantum Computer simulator, so that we can get started writing quantum algorithms
        to run on it. What fun! :)
        """
    ),
]