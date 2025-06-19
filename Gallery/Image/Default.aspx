<%@ Page Title="View Image on RPG" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Gallery.Image.Default" %>

<%@ Register Src="~/templates/controls/SendAsChanger.ascx" TagPrefix="uc1" TagName="SendAsChanger" %>


<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <script>
        function deactivateButton(theBtn) {
            $(theBtn).addClass("disabled");
            $(theBtn).prop('value', "Please Wait...");
            $(theBtn).prop("disabled", true);
            //$(theBtn).hide();
        };
        function Closepopups() {
            $('#MyCharacters').modal('hide');
        }
    </script>
    <asp:HiddenField ID="hdnCommentToDelete" runat="server" />

    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>

    <div class="ButtonPanel clearfix">
        <div class="col-xl-2 col-sm-4 col-xs-12">
            <asp:HyperLink ID="lnkDeleteImage" runat="server" CssClass="btn btn-danger" data-toggle="modal" data-target="#DeleteConfirmation" Visible="false">Delete Image</asp:HyperLink>
        </div>
        <div class="col-xl-2 col-sm-4 col-xs-12 col-xl-offset-3"><a runat="server" id="aEditImage" href="/My-Galleries/Edit-Gallery/?Mode=Edit&GalleryID=0&ImageID=0" class="btn btn-default" visible="false">Edit Image</a></div>
        <div class="col-xl-2 col-sm-4 col-xs-12 col-xl-offset-3"><a runat="server" id="aBackToGallery" href="/Gallery?id=0" class="btn btn-primary">Back to Gallery</a></div>
    </div>

    <div class="GalleryImage clearfix">
        <asp:Image ID="imgGalleryImage" runat="server" CssClass="img-responsive img-thumbnail" />
        <div class="ImageDetails">
            <asp:Panel runat="server" ID="pnlImageCaption" CssClass="caption alert alert-info" Visible="false"></asp:Panel>
        </div>
        <div class="ImageCommentSection" runat="server" id="divImageCommentSection">
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <div class="MakePost clearfix">
                        <div class="col-xs-2 PostAsImage"><%--<a runat="server" id="aSendAs" href="#" data-toggle="modal" data-target="#MyCharacters" class="CharacterImage"></a>--%>
                            <uc1:SendAsChanger runat="server" ID="SendAsChanger" />
                        </div>
                        <div class="col-xs-10 PostText">
                            <%--<asp:TextBox ID="txtPostToStream" runat="server" TextMode="MultiLine" CssClass="form-control" Rows="4" placeholder="No HTML..." MaxLength="475" onkeyDown="return checkTextAreaMaxLength(this,event,'475');"></asp:TextBox>--%>
                            <asp:TextBox ID="txtCommentContent" runat="server" TextMode="MultiLine" CssClass="form-control" Rows="4" placeholder="Please make sure OOC comments are properly labeled." required ValidateRequestMode="Disabled" TabIndex="20"></asp:TextBox>
                        </div>
                    </div>
                    <div class="ButtonPanel clearfix">
                        <div class="col-xl-3 col-sm-4 col-xs-12">
                        </div>
                        <div class="col-xl-3 col-sm-4 col-xs-12">
                        </div>
                        <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                            <asp:LinkButton ID="btnPostComment" runat="server" Text="<span class='glyphicon glyphicon-plus'></span>&nbsp;New Comment" OnClick="btnPostComment_Click" CssClass="btn btn-success" OnClientClick="__doPostBack;deactivateButton(this);" UseSubmitBehavior="false" TabIndex="21" />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnPostComment" />
                </Triggers>
                <ContentTemplate>
                    <div class="ImageComments">
                        <asp:Repeater ID="rptComments" runat="server" DataSourceID="sdsComments" OnItemDataBound="rptComments_ItemDataBound">
                            <ItemTemplate>
                                <div class="Post">
                                    <div class="PostDetails clearfix">
                                        <div class="Creator col-xs-2">
                                            <asp:HyperLink ID="lnkCreator" runat="server" CssClass="CharacterImage"></asp:HyperLink>
                                        </div>
                                        <div class="Content col-xs-10">
                                            <strong class="CharacterName"><a class="<%# Eval("CharacterNameClass") %>" href="/Character?id=<%# Eval("CharacterID") %>"><%# Eval("CharacterDisplayName") %></a><span class="TimeStamp"> <%# ShowTimeAgo(Eval("CommentTimeStamp").ToString()) %> </span></strong>
                                            <span data-linkify><%# Eval("CommentText") %></span>
                                            <div class="ButtonPanel clearfix">
                                                <div class="col-xl-3 col-sm-4 col-xs-12">
                                                    <%--<a runat="server" id="aEditComment" visible="false" class="btn btn-warning" formnovalidate>Edit Comment</a>--%>
                                                </div>
                                                <div class="col-xl-3 col-sm-4 col-xs-12">
                                                    <%--<asp:Button ID="btnCreateThread" runat="server" Text="Create Thread" CssClass="btn btn-primary" Visible="false" formnovalidate />--%>
                                                </div>
                                                <div class="col-xl-3 col-sm-4 col-xs-12">
                                                    <a runat="server" id="aDeleteComment" visible="false" data-toggle="modal" data-target="#confirm-DeleteComment" data-href='<%# Eval("ImageCommentID") %>' class="btn btn-danger">Delete Comment</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:SqlDataSource ID="sdsComments" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [ImageCommentsWithDetails] Where ImageID = @ImageID ORDER BY [CommentTimeStamp] DESC">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="ImageID" QueryStringField="ImageID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div class="modal fade" id="DeleteConfirmation" tabindex="-1" role="dialog" aria-labelledby="DeleteConfirmationLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content alert-danger">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="DeleteConfirmationLabel">Are you sure?</h4>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this picture? Please understand that this will delete it completely and if you don't have any other copies, you should make sure you save it before deleting this one.</p>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnDeleteImage" runat="server" Text="Delete Image" CssClass="btn btn-danger" OnClick="btnDeleteImage_Click" formnovalidate />
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
   
    <div class="modal fade" id="confirm-DeleteComment" tabindex="-1" role="dialog" aria-labelledby="confirm-DeleteCommentLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content alert-danger">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="confirm-DeleteCommentLabel">Are you sure?</h4>
                </div>

                <div class="modal-body">
                    <p>Are you sure you want to delete this comment?</p>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" formnovalidate>Cancel</button>
                    <asp:Button ID="btnDeleteComment" runat="server" Text="Delete Comment" CssClass="btn btn-danger" OnClick="btnDeleteComment_Click" formnovalidate />
                    <%--<a class="btn btn-danger btn-ok">Delete Comment</a>--%>
                </div>
            </div>
        </div>
    </div>
    <script>
        $('#confirm-DeleteComment').on('show.bs.modal', function (e) {
            $(<%=hdnCommentToDelete.ClientID%>).val($(e.relatedTarget).data('href'));
            //$(this).find('.btn-ok').attr('href', $(e.relatedTarget).data('href'));
        });
    </script>
</asp:Content>
