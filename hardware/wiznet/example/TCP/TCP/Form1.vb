Imports System.Net
Imports System.Threading
Imports System.Math

Public Class TCPIP

    Dim TCPClientz As Sockets.TcpClient
    Dim TCPClientStream As Sockets.NetworkStream
    Dim connected As Integer = 1
    Dim RxDataCount As UInt64 = 0
    Dim TxDataCount As UInt64 = 0
    Dim TxBuffer(65536) As Byte
    Dim RxBuffer(65536) As Byte
    Dim RxTest As Integer = 1
    Dim TxTest As Integer = 1
    Dim errormsg As Integer = 0
    Dim tcp_port As UInt16 = 80

    Dim speedstartrx As Double = 0
    Dim speeddiffrx As Double = 0
    Dim speedMbrx As Double = 0

    Dim speedstarttx As Double = 0
    Dim speeddifftx As Double = 0
    Dim speedMbtx As Double = 0

    Private trd As Thread

    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Dim i As UInt64 = 0
        While i < 65534
            TxBuffer(i) = 65
            i += 1
        End While
        TxBuffer(65534) = 66
        TxBuffer(65535) = 10


        'trd = New Thread(AddressOf ThreadTask)
        'trd.IsBackground = True
        'trd.Start()
        'trd = New Thread(AddressOf ThreadTaskRx)
        'trd.IsBackground = True
        'trd.Start()


    End Sub

    Private Sub Timer1_Tick(sender As Object, e As EventArgs) Handles Timer1.Tick
        If connected = 2 Then
            Try
                If TCPClientStream.DataAvailable = True Then
                    Dim rcvbytes(TCPClientz.ReceiveBufferSize) As Byte
                    Dim data0 As UInt32 = 0
                    Dim data1 As UInt32 = 0
                    Dim data2 As UInt32 = 0
                    Dim data3 As UInt32 = 0
                    Dim data4 As UInt32 = 0


                    TCPClientStream.Read(rcvbytes, 0, CInt(TCPClientz.ReceiveBufferSize))
                    If rcvbytes(0) = 180 Then
                        data0 = rcvbytes(1)
                        data1 = data0 * 16777216
                        data0 = rcvbytes(2)
                        data2 = data0 * 65536
                        data0 = rcvbytes(3)
                        data3 = data0 * 256
                        data0 = rcvbytes(4)
                        data4 = data0
                        data0 = data1 + data2 + data3 + data4
                        NumericUpDown5.Value = data0
                    End If
                    If rcvbytes(0) = 181 Then
                        data0 = rcvbytes(1)
                        data1 = data0 * 16777216
                        data0 = rcvbytes(2)
                        data2 = data0 * 65536
                        data0 = rcvbytes(3)
                        data3 = data0 * 256
                        data0 = rcvbytes(4)
                        data4 = data0
                        data0 = data1 + data2 + data3 + data4
                        NumericUpDown8.Value = data0
                    End If
                    If rcvbytes(0) = 183 Then
                        data0 = rcvbytes(1)
                        data1 = data0 * 16777216
                        data0 = rcvbytes(2)
                        data2 = data0 * 65536
                        data0 = rcvbytes(3)
                        data3 = data0 * 256
                        data0 = rcvbytes(4)
                        data4 = data0
                        data0 = data1 + data2 + data3 + data4
                        Label9.Text = "Error count = "
                        Label9.Text += CStr(data0)
                    End If


                End If
            Catch ex As Exception
                errormsg += 1
                If errormsg < 2 Then
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End If
            End Try
        Else
            'Thread.Sleep(1)
        End If

    End Sub

    Private Sub ThreadTaskRx()
        Do
            If connected = 2 Then
                Try
                    If TCPClientStream.DataAvailable = True Then
                        Dim rcvbytes(TCPClientz.ReceiveBufferSize) As Byte
                        Dim rxtemp As UInt64 = 0
                        Dim rxcnt As UInt64 = 0
                        TCPClientStream.Read(rcvbytes, 0, CInt(TCPClientz.ReceiveBufferSize))

                        While rxtemp < 65536
                            If rcvbytes(rxtemp) <> 0 Then
                                rxcnt += 1
                            End If
                            rxtemp += 1
                        End While
                        RxDataCount += rxcnt
                    End If
                Catch ex As Exception
                    errormsg += 1
                    If errormsg < 2 Then
                        MsgBox("Error:" & vbCrLf & ex.Message)
                    End If
                End Try
            Else
                'Thread.Sleep(1)
            End If
        Loop

    End Sub

    Private Sub ThreadTask()
        Do
            If connected = 2 Then

                If connected = 2 Then
                    If TxTest = 2 Then
                        Try
                            'Dim Txbuffercount As UInt32 = NumericUpDown1.Value
                            'TxDataCount += Txbuffercount
                            'TCPClientz.Client.Send(TxBuffer, 0, Txbuffercount, 0)
                        Catch ex As Exception
                            errormsg += 1
                            If errormsg < 2 Then
                                MsgBox("Error:" & vbCrLf & ex.Message)
                            End If
                        End Try
                    End If
                End If

            Else
                'Thread.Sleep(1)
            End If


        Loop
    End Sub




    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click

        If connected = 1 Then
            Try
                speedstartrx = speeddiffrx = speedMbrx = speedstarttx = speeddifftx = speedMbtx = 0
                TCPClientz = New Sockets.TcpClient(TextBox1.Text, tcp_port)
                TCPClientz.Client.SendBufferSize = 65536
                TCPClientz.Client.ReceiveBufferSize = 65536
                Timer1.Enabled = True
                TCPClientStream = TCPClientz.GetStream()
                Button1.Text = "Connected !"
                connected = 2
                RxDataCount = 0
            Catch ex As Exception
                errormsg += 1
                If errormsg < 2 Then
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End If
            End Try
        Else
            Try
                speedstartrx = speeddiffrx = speedMbrx = speedstarttx = speeddifftx = speedMbtx = 0
                connected = 1
                Thread.Sleep(10)
                Timer1.Enabled = False

                TCPClientz.Client.Close()
                TCPClientz.Close()
                TCPClientz.Client.Dispose()
                Button1.Text = "Disconnected !"
                connected = 1
            Catch ex As Exception
                errormsg += 1
                If errormsg < 2 Then
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End If
            End Try

        End If

    End Sub





    Private Sub Button4_Click(sender As Object, e As EventArgs)

        If connected = 2 Then
            Dim sendbytes(2) As Byte
            If RxTest = 1 Then
                RxTest = 2
                sendbytes(0) = 83
                sendbytes(1) = 84
                Try
                    TCPClientz.Client.Send(sendbytes, 0, 2, 0)
                Catch ex As Exception
                    errormsg += 1
                    If errormsg < 2 Then
                        MsgBox("Error:" & vbCrLf & ex.Message)
                    End If
                End Try

                Button4.Text = "STOP Rx"
            Else
                RxTest = 1
                sendbytes(0) = 83
                sendbytes(1) = 80
                Try
                    TCPClientz.Client.Send(sendbytes, 0, 2, 0)
                Catch ex As Exception
                    errormsg += 1
                    If errormsg < 2 Then
                        MsgBox("Error:" & vbCrLf & ex.Message)
                    End If
                End Try

                Button4.Text = "START Rx"
            End If
        End If
    End Sub



    Private Sub Button4_Click_1(sender As Object, e As EventArgs) Handles Button4.Click
        If connected = 2 Then
            Dim sendbytes(10) As Byte
            sendbytes(0) = 170  'sync
            sendbytes(1) = 10 'write upcude
            sendbytes(2) = (NumericUpDown2.Value And 4278190080) >> 24
            sendbytes(3) = (NumericUpDown2.Value And 16711680) >> 16
            sendbytes(4) = (NumericUpDown2.Value And 65280) >> 8
            sendbytes(5) = (NumericUpDown2.Value And 255)

            sendbytes(6) = (NumericUpDown3.Value And 4278190080) >> 24
            sendbytes(7) = (NumericUpDown3.Value And 16711680) >> 16
            sendbytes(8) = (NumericUpDown3.Value And 65280) >> 8
            sendbytes(9) = (NumericUpDown3.Value And 255)

            Try
                TCPClientz.Client.Send(sendbytes, 0, 10, 0)
            Catch ex As Exception
                errormsg += 1
                If errormsg < 2 Then
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End If
            End Try
        End If
    End Sub

    Private Sub Button5_Click(sender As Object, e As EventArgs) Handles Button5.Click
        If connected = 2 Then
            Dim sendbytes(10) As Byte
            sendbytes(0) = 170  'sync
            sendbytes(1) = 20 'write upcude
            sendbytes(2) = (NumericUpDown4.Value And 4278190080) >> 24
            sendbytes(3) = (NumericUpDown4.Value And 16711680) >> 16
            sendbytes(4) = (NumericUpDown4.Value And 65280) >> 8
            sendbytes(5) = (NumericUpDown4.Value And 255)

            sendbytes(6) = 0
            sendbytes(7) = 0
            sendbytes(8) = 0
            sendbytes(9) = 0

            Try
                TCPClientz.Client.Send(sendbytes, 0, 10, 0)
            Catch ex As Exception
                errormsg += 1
                If errormsg < 2 Then
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End If
            End Try
        End If
    End Sub



    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        If connected = 2 Then
            Dim sendbytes(10) As Byte
            sendbytes(0) = 171  'sync
            sendbytes(1) = 10 'write upcude
            sendbytes(2) = (NumericUpDown1.Value And 4278190080) >> 24
            sendbytes(3) = (NumericUpDown1.Value And 16711680) >> 16
            sendbytes(4) = (NumericUpDown1.Value And 65280) >> 8
            sendbytes(5) = (NumericUpDown1.Value And 255)

            sendbytes(6) = (NumericUpDown6.Value And 4278190080) >> 24
            sendbytes(7) = (NumericUpDown6.Value And 16711680) >> 16
            sendbytes(8) = (NumericUpDown6.Value And 65280) >> 8
            sendbytes(9) = (NumericUpDown6.Value And 255)

            Try
                TCPClientz.Client.Send(sendbytes, 0, 10, 0)
            Catch ex As Exception
                errormsg += 1
                If errormsg < 2 Then
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End If
            End Try
        End If
    End Sub

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles Button3.Click
        If connected = 2 Then
            Dim sendbytes(10) As Byte
            sendbytes(0) = 171  'sync
            sendbytes(1) = 20 'write upcude
            sendbytes(2) = (NumericUpDown7.Value And 4278190080) >> 24
            sendbytes(3) = (NumericUpDown7.Value And 16711680) >> 16
            sendbytes(4) = (NumericUpDown7.Value And 65280) >> 8
            sendbytes(5) = (NumericUpDown7.Value And 255)

            sendbytes(6) = 0
            sendbytes(7) = 0
            sendbytes(8) = 0
            sendbytes(9) = 0

            Try
                TCPClientz.Client.Send(sendbytes, 0, 10, 0)
            Catch ex As Exception
                errormsg += 1
                If errormsg < 2 Then
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End If
            End Try
        End If
    End Sub

    Private Sub Button6_Click(sender As Object, e As EventArgs) Handles Button6.Click
        If connected = 2 Then
            Dim sendbytes(10) As Byte
            sendbytes(0) = 190 'sync
            sendbytes(1) = 1 'write upcude

            Try
                TCPClientz.Client.Send(sendbytes, 0, 2, 0)
            Catch ex As Exception
                errormsg += 1
                If errormsg < 2 Then
                    MsgBox("Error:" & vbCrLf & ex.Message)
                End If
            End Try
        End If
    End Sub

    Private Sub Label9_Click(sender As Object, e As EventArgs) Handles Label9.Click

    End Sub
End Class
