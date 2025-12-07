Imports System.Net

Public Class TCPIP

    Dim TCPClientz As Sockets.TcpClient
    Dim TCPClientStream As Sockets.NetworkStream
    Dim connected As Integer = 1
    Dim RxDataCount As UInt64 = 0
    Dim TxDataCount As UInt64 = 0
    Dim TxBuffer(65536) As Byte
    Dim RxTest As Integer = 1
    Dim TxTest As Integer = 1

    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Dim i As UInt64 = 0
        While i < 65534
            TxBuffer(i) = 65
            i += 1
        End While
        TxBuffer(65534) = 66
        TxBuffer(65535) = 10
        ProgressBar1.Maximum = 10
        ProgressBar1.Minimum = 0.01
        ProgressBar2.Maximum = 10
        ProgressBar2.Minimum = 0.01
        ProgressBar1.Step = 0.01
        ProgressBar2.Step = 0.01
        'Control.Controls.Add(Label1)
        Label2.BackColor = Color.Transparent
        Label3.BackColor = Color.Transparent
        Label3.Text = "0.000MB/s"
        Label2.Text = "0.000MB/s"
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        If connected = 2 Then
            Try
                Dim sendbytes() As Byte = System.Text.Encoding.ASCII.GetBytes(TextBox2.Text)
                Label1.Text = sendbytes.Length
                TCPClientz.Client.Send(sendbytes)
            Catch ex As Exception
                MsgBox("Error:" & vbCrLf & ex.Message)
            End Try
        End If
    End Sub


    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click

        If connected = 1 Then
            Try
                TCPClientz = New Sockets.TcpClient(TextBox1.Text, 15000)
                TCPClientz.Client.SendBufferSize = 65536
                TCPClientz.Client.ReceiveBufferSize = 65536
                Timer1.Enabled = True
                Speed.Enabled = True
                TCPClientStream = TCPClientz.GetStream()
                Button1.Text = "Connected !"
                connected = 2
                RxDataCount = 0
            Catch ex As Exception
                MsgBox("Error:" & vbCrLf & ex.Message)
            End Try
        Else
            Try
                Timer1.Enabled = False
                Speed.Enabled = False
                TCPClientz.Client.Close()
                TCPClientz.Close()
                TCPClientz.Client.Dispose()
                Button1.Text = "Disconnected !"
                connected = 1
            Catch ex As Exception
                MsgBox("Error:" & vbCrLf & ex.Message)
            End Try

        End If

    End Sub


    Private Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        Try
            If TCPClientStream.DataAvailable = True Then
                Dim rcvbytes(TCPClientz.ReceiveBufferSize) As Byte
                Dim rxtemp As UInt64 = 0
                Dim rxcnt As UInt64 = 0
                TCPClientStream.Read(rcvbytes, 0, CInt(TCPClientz.ReceiveBufferSize))
                If CheckBox1.Checked = True Then
                    RichTextBox1.Text = RichTextBox1.Text + System.Text.Encoding.ASCII.GetString(rcvbytes)
                End If
                While rxtemp < 65536
                    If rcvbytes(rxtemp) <> 0 Then
                        rxcnt += 1
                    End If
                    rxtemp += 1
                End While
                RxDataCount += rxcnt
            End If
        Catch ex As Exception
            MsgBox("Error:" & vbCrLf & ex.Message)
        End Try
        If connected = 2 Then
            If TxTest = 2 Then
                Try
                    Dim Txbuffercount As UInt32 = NumericUpDown1.Value
                    TxDataCount += Txbuffercount
                    TCPClientz.Client.Send(TxBuffer, 0, Txbuffercount, 0)
                Catch ex As Exception
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End Try
            End If
        End If
    End Sub


    Dim speedstartrx As Double = 0
    Dim speeddiffrx As Double = 0
    Dim speedMbrx As Double = 0

    Dim speedstarttx As Double = 0
    Dim speeddifftx As Double = 0
    Dim speedMbtx As Double = 0

    Private Sub Speed_Tick(sender As Object, e As EventArgs) Handles Speed.Tick
        speeddiffrx = RxDataCount - speedstartrx
        speedstartrx = RxDataCount
        speedMbrx = (speeddiffrx * 10) / (1024 * 1024)
        Label3.Text = speedMbrx.ToString("#0.000MB/s") '
        ProgressBar1.Value = speedMbrx

        speeddifftx = TxDataCount - speedstarttx
        speedstarttx = TxDataCount
        speedMbtx = (speeddifftx * 10) / (1024 * 1024)
        Label2.Text = speedMbtx.ToString("#0.000MB/s")
        ProgressBar2.Value = speedMbtx
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        If connected = 2 Then
            Try
                Dim sendbytes(4) As Byte
                sendbytes(0) = 66
                sendbytes(1) = 83
                If NumericUpDown1.Value > 65535 Then
                    NumericUpDown1.Value = 65534
                End If
                sendbytes(2) = NumericUpDown1.Value >> 8
                sendbytes(3) = NumericUpDown1.Value And 255
                TCPClientz.Client.Send(sendbytes, 0, 4, 0)
            Catch ex As Exception
                MsgBox("Error:" & vbCrLf & ex.Message)
            End Try
        End If
    End Sub


    Private Sub Button4_Click(sender As Object, e As EventArgs) Handles Button4.Click

        If connected = 2 Then
            Dim sendbytes(2) As Byte
            If RxTest = 1 Then
                RxTest = 2
                sendbytes(0) = 83
                sendbytes(1) = 84
                Try
                    TCPClientz.Client.Send(sendbytes, 0, 2, 0)
                Catch ex As Exception
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End Try

                Button4.Text = "STOP Rx"
            Else
                RxTest = 1
                sendbytes(0) = 83
                sendbytes(1) = 80
                Try
                    TCPClientz.Client.Send(sendbytes, 0, 2, 0)
                Catch ex As Exception
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End Try

                Button4.Text = "START Rx"
            End If
        End If
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        If connected = 2 Then
            If TxTest = 1 Then
                TxTest = 2
                Button5.Text = "STOP Tx"
            Else
                TxTest = 1
                Button5.Text = "START Tx"
            End If
        End If
    End Sub


End Class
