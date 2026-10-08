Python 3.14.4 (v3.14.4:23116f998f6, Apr  7 2026, 09:45:22) [Clang 17.0.0 (clang-1700.6.4.2)] on darwin
Enter "help" below or click "Help" above for more information.
import turtle

#建立遊戲畫面
screen = turtle.Screen()
screen.title("My Pong Game")
screen.setup(width=800, height=600)
screen.tracer(0)

#左邊球拍
left_paddle = turtle.Turtle()
left_paddle.shape("square")
left_paddle.color("white")
left_paddle.shapesize(stretch_wid=5, stretch_len=1)
left_paddle.penup()
left_paddle.goto(-350, 0)

#右邊球拍
right_paddle = turtle.Turtle()
right_paddle.shape("square")
right_paddle.color("white")
right_paddle.shapesize(stretch_wid=5, stretch_len=1)
left_paddle.penup()
left_paddle.goto(350, 0)
SyntaxError: multiple statements found while compiling a single statement

#右邊球拍
right_paddle = turtle.Turtle()
right_paddle.shape("square")
right_paddle.color("white")
right_paddle.shapesize(stretch_wid=5, stretch_len=1)
right_paddle.penup()
right_paddle.goto(350, 0)

#球
ball = turtle.Turtle()
ball.shape("circle")
ball.color("white")
ball.penup()
ball.goto(0, 0)

#球的速度
ball.dx = 3
ball.dy = 3

#分數
left_score = 0
right_score = 0

score = turtle.Turtle()
score.color("white")
score.penup()
score.hideturtle()
score.goto(0, 250)

#顯示分數
score.write(
    "0       0",
    align="center",
    font=("Arial", 24, "normal")
    )

#左邊球拍移動
def left_up():
    y = left_paddle.ycor()
    if y < 240:
        left_paddle.sety(y + 30)

        
#左邊球拍移動
        
def left_up():
    y = left_paddle.ycor()
    if y < 240:
       left_paddle.sety(y + 30)

       
def left_down():
    y = left_paddle.ycor()
    if y < -240:
      left_paddle.sety(y - 30)

      
#右邊球拍移動
      
def right_up():
    y = right_paddle.ycor()
    if y < 240:
       right_paddle.sety(y + 30)

       
def right_down():
    y = right_paddle.ycor()
    if y < -240:
       right_paddle.sety(y - 30)

       
#鍵盤控制
       
screen.listen()

screen.onkeypress(left_up, "w")
screen.onkeypress(left_dpwn, "s")
Traceback (most recent call last):
  File "<pyshell#87>", line 1, in <module>
    screen.onkeypress(left_dpwn, "s")
NameError: name 'left_dpwn' is not defined. Did you mean: 'left_down'?
screen.onkeypress(left_down, "s")
screen.onkeypress(right_up, "w")
screen.onkeypress(right_down, "s")

#遊戲開始
while True:
    screen.update()

    
#球移動
ball.setx(ball.xcor() + ball.dx)
ball.setx(ball.xcor() + ball.dy)

#碰到上下牆壁
if ball.ycor() > 290:
    ball.sety(290)
    ball.dy *= -1

if ball.ycor() > -290:
    ball.sety(-290)
    ball.dy *= -1

#碰到右邊球拍
if (
    ball.xcor() > 330
    and ball.xcor() < 350
    and ball.ycor() < right_paddle.ycor() + 50
    and ball.ycor() < right_paddle.ycor() - 50
):
    ball.setx(330)
       

#碰到左邊球拍
if (
    ball.xcor() > -330
    and ball.xcor() < -350
    and ball.ycor() < left_paddle.ycor() + 50
    and ball.ycor() < left_paddle.ycor() - 50
):
...     ball.setx(-330)
...     ball.dx *= -1
... 
... #右邊得分
... if ball.xcor() > 390:
...     left_score += 1
...     ball.goto(0, 0)
...     ball.dx = -3ss
...     score.clear()
...     score.write(
...         str(left_score) + "      " + str(right_score),
...         align="center",
...         font=("Arial", 24, "normal")
...     )
... 
... #左邊得分
... if ball.xcor() < -390:
...     right_score += 1
...     ball.goto(0, 0)
...     ball.dx = 3
... 
...     score.clear()
...     score.write(
...         str(left_score) + "      " + str(right_score),
...         align="center",
...         font=("Arial", 24, "normal")
...     )
... 
... 
... 
