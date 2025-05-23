
using Amazon.S3;
using Amazon.S3.IO;
using Amazon.S3.Transfer;
using System;
using System.Configuration;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;

namespace RolePlayersGuild
{
    public class ImageFunctions
    {
        public static void DeleteImage(string ImageName)
        {
            string directoryVirtual = ConfigurationManager.AppSettings["CharacterImagesFolder"].ToString();
            string bucketName = ConfigurationManager.AppSettings["AWSBucketName"].ToString();
            
            AmazonS3Client AWSClient = new AmazonS3Client(Amazon.RegionEndpoint.USEast1);
            S3FileInfo s3FullFileInfo = new S3FileInfo(AWSClient, bucketName, directoryVirtual + "fullimg_" + ImageName);
            if (s3FullFileInfo.Exists)
            {
                s3FullFileInfo.Delete();
            }
            S3FileInfo s3ThumbFileInfo = new S3FileInfo(AWSClient, bucketName, directoryVirtual + "thumbimg_" + ImageName);
            if (s3ThumbFileInfo.Exists)
            {
                s3ThumbFileInfo.Delete();
            }
        }
        public static string UploadImage(FileUpload fuCharacterProfileImage)
        {
            if (fuCharacterProfileImage.HasFile)
            {
                string fileExtension = Path.GetExtension(fuCharacterProfileImage.PostedFile.FileName);

                AmazonS3Client AWSClient = new AmazonS3Client(Amazon.RegionEndpoint.USEast1);
                string directoryVirtual = ConfigurationManager.AppSettings["CharacterImagesFolder"].ToString();
                string bucketName = ConfigurationManager.AppSettings["AWSBucketName"].ToString();

                int fileNameCharacterLength = 4;
                string fileName = StringFunctions.GenerateRandomString(fileNameCharacterLength);

                S3FileInfo s3FullFileInfo = new S3FileInfo(AWSClient, bucketName, directoryVirtual + "fullimg_" + fileName + fileExtension);
                S3FileInfo s3ThumbFileInfo = new S3FileInfo(AWSClient, bucketName, directoryVirtual + "thumbimg_" + fileName + fileExtension);

                while (s3FullFileInfo.Exists || s3ThumbFileInfo.Exists)
                {
                    fileNameCharacterLength += 1;
                    fileName = StringFunctions.GenerateRandomString(fileNameCharacterLength);
                }

                Bitmap originalBMP = new Bitmap(fuCharacterProfileImage.FileContent);

                var newWidth = originalBMP.Width;
                var newHeight = originalBMP.Height;
                double maxWidth = 900;
                double maxHeight = 1200;

                if (newWidth > maxWidth || newHeight > maxHeight)
                {
                    // Calculate the new image dimensions
                    var ratioX = maxWidth / originalBMP.Width;
                    var ratioY = maxHeight / originalBMP.Height;
                    var ratio = Math.Min(ratioX, ratioY);

                    newWidth = (int)(originalBMP.Width * ratio);
                    newHeight = (int)(originalBMP.Height * ratio);
                }

                Bitmap newBMP = new Bitmap(newWidth, newHeight);//, PixelFormat.Format16bppRgb555);
                Graphics oGraphics = Graphics.FromImage(newBMP);

                oGraphics.DrawImage(originalBMP, 0, 0, newWidth, newHeight);

                TransferUtility fileTransferUtility = new TransferUtility(AWSClient);
                using (var FullImgStream = new MemoryStream())
                {
                    ImageCodecInfo jpegCodec = GetEncoderInfo("image/jpeg");
                    EncoderParameters encoderParameters = new EncoderParameters(1);
                    encoderParameters.Param[0] = new EncoderParameter(Encoder.Quality, 100L); ;

                    newBMP.Save(FullImgStream, jpegCodec, encoderParameters);
                    FullImgStream.Position = 0;
                    fileTransferUtility.Upload(FullImgStream, bucketName, directoryVirtual + "fullimg_" + fileName + fileExtension);
                }
                newBMP.Dispose();
                oGraphics.Dispose();


                var newThumbWidth = originalBMP.Width;
                var newThumbHeight = originalBMP.Height;
                double maxThumbWidth = 300;
                double maxThumbHeight = 300;

                if (newThumbWidth > maxThumbWidth || newThumbWidth > maxThumbHeight)
                {
                    // Calculate the new image dimensions
                    var ratioX = maxThumbWidth / originalBMP.Width;
                    var ratioY = maxThumbHeight / originalBMP.Height;
                    var ratio = Math.Min(ratioX, ratioY);

                    newThumbWidth = (int)(originalBMP.Width * ratio);
                    newThumbHeight = (int)(originalBMP.Height * ratio);
                }

                Bitmap newThumbBMP = new Bitmap(newThumbWidth, newThumbHeight);//, PixelFormat.Format16bppRgb555);
                Graphics oThumbGraphics = Graphics.FromImage(newThumbBMP);

                oThumbGraphics.DrawImage(originalBMP, 0, 0, newThumbWidth, newThumbHeight);

                using (var ThumbImgStream = new MemoryStream())
                {
                    ImageCodecInfo jpegCodec = GetEncoderInfo("image/jpeg");
                    EncoderParameters encoderParameters = new EncoderParameters(1);
                    encoderParameters.Param[0] = new EncoderParameter(Encoder.Quality, 94L); ;

                    newThumbBMP.Save(ThumbImgStream, jpegCodec, encoderParameters);
                    ThumbImgStream.Position = 0;
                    fileTransferUtility.Upload(ThumbImgStream, bucketName, directoryVirtual + "thumbimg_" + fileName + fileExtension);
                }
                newThumbBMP.Dispose();
                oThumbGraphics.Dispose();

                originalBMP.Dispose();

                string fullFilePath = fileName + fileExtension;

                return fullFilePath;
            }
            else {
                return "";
            }
        }
        private static ImageCodecInfo GetEncoderInfo(string mimeType)
        {
            // Get image codecs for all image formats 
            ImageCodecInfo[] codecs = ImageCodecInfo.GetImageEncoders();

            // Find the correct image codec 
            for (int i = 0; i < codecs.Length; i++)
                if (codecs[i].MimeType == mimeType)
                    return codecs[i];

            return null;
        }
    }
}