using System;
using System.Web.UI;
using Telerik.Web.UI;
using System.IO;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;

public partial class Default : System.Web.UI.Page 
{
    private List<string> ImageFiles = new List<string>();
    private List<string> FrameNames = new List<string>();

    protected void Page_Load(object sender, EventArgs e)
    {
        // Handles var include in header
        Page.Header.DataBind();
    }

    protected void RadAsyncUpload1_FileUploaded(object sender, FileUploadedEventArgs e)
    {
        string FilePath = Server.MapPath("~/Uploads/");
        string sessionID = this.Session.SessionID + "_";
        e.File.SaveAs(FilePath + sessionID + e.File.GetName());
        Session["FileUpload"] = sessionID + e.File.FileName;
    }

    private bool FormatValid(string format)
    {
        string allowableLetters = "0123456789";

        foreach (char c in format)
        {
            if (!allowableLetters.Contains(c.ToString()))
                return false;
        }

        return true;
    }

    public static Bitmap ResizeImage(System.Drawing.Image image, int width, int height)
    {
        var destRect = new Rectangle(0, 0, width, height);
        var destImage = new Bitmap(width, height);

        destImage.SetResolution(image.HorizontalResolution, image.VerticalResolution);

        using (var graphics = Graphics.FromImage(destImage))
        {
            graphics.InterpolationMode = InterpolationMode.NearestNeighbor;
            graphics.SmoothingMode = SmoothingMode.None;
            using (var wrapMode = new ImageAttributes())
            {
                wrapMode.SetWrapMode(WrapMode.TileFlipXY);
                graphics.DrawImage(image, destRect, 0, 0, image.Width, image.Height, GraphicsUnit.Pixel, wrapMode);
            }
        }

        return destImage;
    }

    protected void lbUploadFile_Click(object sender, EventArgs e)
    {
        string sUploadFile = "";
        try
        {
            sUploadFile = Session["FileUpload"].ToString();
        }
        catch { }

        string DefScript = "";
        DefScript += "var imgArray = new Array();";
        DefScript += "var nameArray = new Array();";
        DefScript += "imgFrame.src='template/empty.png';";
        DefScript += "document.getElementById('lblFrame').innerText='Frame Title:';";
        DefScript += "notImages();";
        DefScript += "haveImages=false;";
        DefScript += "counter=-1;";

        if (sUploadFile != "")
        {
            // Check file extension
            if (Path.GetExtension(sUploadFile).ToUpper() != ".TXT")
            {
                // Register script block
                RadScriptManager.RegisterStartupScript(Page, Page.GetType(), "1", DefScript, true);

                lblUploadMsg.Text = "";
                lblUploadError.Visible = true;
                lblUploadError.Text = "Uploaded file should have .txt extension";
                Session["FileUpload"] = "";
            }
            else
            {
                try
                {
                    // Read in entire text file
                    string FilePath = Server.MapPath("~/Uploads/");
                    string SavePath = Server.MapPath("~/images/");
                    string sessionID = this.Session.SessionID + "_";
                    string TimeStamp = DateTime.Now.ToString("yyyyMMddHHmmssfff") + "_";

                    string[] readText = File.ReadAllLines(FilePath + sUploadFile);

                    string ErrorMsg = "";
                    bool ValidFrames = true;
                    bool StartFrame = true;
                    int NumLines = 0;
                    List<string> FrameLines = new List<string>();

                    ImageFiles.Clear();
                    FrameNames.Clear();
                    foreach (string sLine in readText)
                    {
                        if (ValidFrames)
                        {
                            if (StartFrame)
                            {
                                // This line is the frame start
                                FrameNames.Add(sLine);
                                FrameLines.Clear();
                                NumLines = 0;
                                StartFrame = false;
                            }
                            else
                            {
                                NumLines++;
                                FrameLines.Add(sLine);
                                ValidFrames = FormatValid(sLine);
                                if (ValidFrames)
                                {
                                    if (sLine.Length < 75)
                                    {
                                        ValidFrames = false;
                                        ErrorMsg = "Line Too Short in Frame# " + FrameNames.Count.ToString();
                                    }
                                    else
                                    {
                                        if (sLine.Length > 75)
                                        {
                                            ValidFrames = false;
                                            ErrorMsg = "Line Too Long in Frame# " + FrameNames.Count.ToString();
                                        }
                                    }
                                    if (ValidFrames)
                                    {
                                        if (NumLines < 50)
                                        {
                                        }
                                        else
                                        {
                                            StartFrame = true;

                                            if (ValidFrames)
                                            {
                                                // Ready to make bitmap
                                                Bitmap myBitmap = new Bitmap(75, 50);

                                                for (int y=0;y < FrameLines.Count;y++)
                                                {
                                                    string thisLine = FrameLines[y];
                                                    for (int x=0;x < thisLine.Length;x++)
                                                    {
                                                        string thisChar = thisLine.Substring(x, 1);
                                                        switch (thisChar)
                                                        {
                                                            case "0": // Water
                                                                myBitmap.SetPixel(x, y, Color.Blue);
                                                                break;
                                                            case "1": // Fish
                                                                myBitmap.SetPixel(x, y, Color.Green);
                                                                break;
                                                            case "2": // Sharks
                                                                myBitmap.SetPixel(x, y, Color.Orange);
                                                                break;
                                                            case "3": // Mystery
                                                                myBitmap.SetPixel(x, y, Color.Purple);
                                                                break;
                                                            case "4": // Mystery
                                                                myBitmap.SetPixel(x, y, Color.Black);
                                                                break;
                                                            case "5":
                                                                myBitmap.SetPixel(x, y, Color.Tan);
                                                                break;
                                                            case "6":
                                                                myBitmap.SetPixel(x, y, Color.Teal);
                                                                break;
                                                            case "7":
                                                                myBitmap.SetPixel(x, y, Color.Red);
                                                                break;
                                                            case "8":
                                                                myBitmap.SetPixel(x, y, Color.Brown);
                                                                break;
                                                            case "9":
                                                                myBitmap.SetPixel(x, y, Color.Pink);
                                                                break;
                                                        }

                                                    }
                                                }

                                                Bitmap myResize = ResizeImage(myBitmap, 450, 300);
                                                string NewFilename = sessionID + TimeStamp + "frame" + FrameNames.Count.ToString() + ".png";
                                                myResize.Save(SavePath + NewFilename);

                                                ImageFiles.Add(NewFilename);
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    ErrorMsg = "Invalid Characters in Frame# " + FrameNames.Count.ToString();
                                }
                            }
                        }
                    }
                    if (ValidFrames)
                    {
                        if (FrameNames.Count != ImageFiles.Count)
                        {
                            ValidFrames = false;
                            ErrorMsg = "Not Enough Lines in Last Frame";
                        }
                    }

                    // Image creation


                    if (ValidFrames)
                    {
                        // Register script block
                        string ImgScript = "";
                        ImgScript += "var imgArray = new Array();";
                        ImgScript += "var nameArray = new Array();";
                        for (int i = 0; i < FrameNames.Count; i++)
                        {
                            ImgScript += "imgArray[" + i.ToString() + "] = new Image();";
                            ImgScript += "imgArray[" + i.ToString() + "].src = 'images/" + ImageFiles[i] + "';";
                            ImgScript += "nameArray[" + i.ToString() + "] = '" + FrameNames[i] + "';";
                        }
                        ImgScript += "imgFrame.src=imgArray[0].src;";
                        ImgScript += "document.getElementById('lblFrame').innerText=nameArray[0];";
                        ImgScript += "gotImages();";
                        ImgScript += "haveImages=true;";
                        ImgScript += "counter=0;";

                        RadScriptManager.RegisterStartupScript(Page, Page.GetType(), "1", ImgScript, true);

                        // Update messages
                        lblUploadMsg.Text = "&nbsp;";
                        lblUploadError.Visible = false;
                        Session["FileUpload"] = "";
                    }
                    else
                    {
                        // Register script block
                        RadScriptManager.RegisterStartupScript(Page, Page.GetType(), "1", DefScript, true);

                        lblUploadMsg.Text = "";
                        lblUploadError.Visible = true;
                        lblUploadError.Text = ErrorMsg;
                        Session["FileUpload"] = "";
                    }
                }
                catch (Exception ex)
                {
                    // Register script block
                    RadScriptManager.RegisterStartupScript(Page, Page.GetType(), "1", DefScript, true);

                    lblUploadMsg.Text = "";
                    lblUploadError.Visible = true;
                    lblUploadError.Text = "There was an error in processing this file";
                    Session["FileUpload"] = "";
                }
            }
        }
        else
        {
            // Register script block
            RadScriptManager.RegisterStartupScript(Page, Page.GetType(), "1", DefScript, true);

            lblUploadMsg.Text = "";
            lblUploadError.Visible = true;
            lblUploadError.Text = "You must select a file to upload first";
            Session["FileUpload"] = "";
        }
    }
}
