<%@ Page Title="" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Story.Posts.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>
<%@ Register TagPrefix="uc1" TagName="SendAsChanger" Src="~/templates/controls/SendAsChanger.ascx" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" CurrentParent="Stories" />
    <div runat="server" id="divThreadAd">
        <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
        <!-- ThreadsAd -->
        <ins class="adsbygoogle"
            style="display: block"
            data-ad-client="ca-pub-1247828126747788"
            data-ad-slot="7028871313"
            data-ad-format="auto"></ins>
        <script>
            (adsbygoogle = window.adsbygoogle || []).push({});
        </script>
    </div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="cphRightCol" runat="server">
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
    <asp:HiddenField ID="hdnPostToDelete" runat="server" />
    <div id="fb-root"></div>
    <script>(function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.5";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));</script>
    <script>!function (d, s, id) { var js, fjs = d.getElementsByTagName(s)[0], p = /^http:/.test(d.location) ? 'http' : 'https'; if (!d.getElementById(id)) { js = d.createElement(s); js.id = id; js.src = p + '://platform.twitter.com/widgets.js'; fjs.parentNode.insertBefore(js, fjs); } }(document, 'script', 'twitter-wjs');</script>
    <asp:Panel ID="pnlMessage" runat="server" ViewStateMode="Disabled" Visible="false" role="alert">
        <asp:Literal ID="litMessage" runat="server" ViewStateMode="Disabled"></asp:Literal>
    </asp:Panel>
    <div class="ButtonPanel clearfix">
        <div class="col-sm-3 col-xs-12">
            <a href="/Story/List/" class="btn btn-default">Back To Stories</a>
        </div>
        <div class="col-sm-3 col-xs-12">
        </div>
        <div class="col-sm-3 col-xs-12">
            <asp:HyperLink ID="lnkViewUniverse" runat="server" Text="View Universe" CssClass="btn btn-primary" />
        </div>
        <div runat="server" id="liAdminConsole" class="col-sm-3 col-xs-12" visible="false">
            <a href="/Admin/Stories?id=<%= Request.QueryString["storyid"].ToString() %>" class="btn btn-primary staff">Admin Console</a>
        </div>
    </div>
    <div class="FullWidthPostSection" runat="server" id="divSubmitPostSection">
        <div class="MakePost clearfix">
            <div class="col-xs-2 col-xl-1 PostAsImage">
                <uc1:SendAsChanger runat="server" ID="SendAsChanger" />
            </div>
            <div class="col-xs-10 col-xl-11 PostText">
                <asp:TextBox ID="txtPostContent" runat="server" TextMode="MultiLine" CssClass="form-control" Rows="4" placeholder="Please make sure OOC posts are properly labeled." required ValidateRequestMode="Disabled" TabIndex="20"></asp:TextBox>
            </div>
        </div>
        <div class="ButtonPanel clearfix">
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12">
            </div>
            <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3">
                <asp:LinkButton ID="btnSubmitPost" runat="server" Text="<span class='glyphicon glyphicon-plus'></span>&nbsp;Submit Post" OnClick="btnSubmitPost_Click" CssClass="btn btn-success" OnClientClick="__doPostBack;deactivateButton(this);" UseSubmitBehavior="false" TabIndex="21" />
            </div>
        </div>
    </div>
    <br />
    <asp:Panel ID="pnlContent" runat="server" CssClass="col-xs-12">
        <asp:Panel runat="server" ID="pnlFullThread" CssClass="FullThread">
            <asp:Repeater ID="rptMessages" runat="server" OnItemDataBound="rptMessages_ItemDataBound">
                <ItemTemplate>
                    <div class="ThreadMessage">
                        <div class="MessageInfo">
                            <ul>
                                <li class="UserName"><a href="/Character?id=<%#Eval("CharacterID") %>" class="<%# Eval("CharacterNameClass") %>"><%#Eval("CharacterDisplayName") %></a></li>
                                <li runat="server" id="liUserImage" clientidmode="Predictable" class="UserImage"><a href="/Character?id=<%#Eval("CharacterID") %>">
                                    <img src="<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "thumb") %>" /></a></li>
                                <li runat="server" id="liUserOnline" class="UserOnline" visible="false">Online</li>
                                <li runat="server" id="liEditMessage" Visible="False"><a href="/My-Stories/Edit-Post/?PostID=<%#Eval("StoryPostID") %>">Edit Post</a></li>
                                <li runat="server" id="liDeletePost" Visible="False"><a data-toggle="modal" data-target="#confirm-DeletePost" data-href='<%# Eval("StoryPostID") %>' href="#">Delete Post</a>
                                </li>
                                <%--<li runat="server" id="liBlockUser"><a href="#">Block User</a></li>--%>
                            </ul>
                        </div>
                        <div class="MessageContent">
                            <p class="small" style="padding: 0; margin: 0 0 5px 0;"><small>Posted: <%#ShowTimeAgo(Eval("PostDateTime").ToString())%></small></p>
                            <span data-linkify><%# Eval("PostContent").ToString() %></span>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>
        <nav class="PagingControls">
            <ul class="pagination">
                <%--                    <li>
                        <asp:LinkButton ID="lbFirst" runat="server"
                            OnClick="lbFirst_Click">Newest</asp:LinkButton>
                    </li>--%>
                <li class="previous">
                    <asp:LinkButton ID="lbFirst" runat="server"
                        OnClick="lbFirst_Click" aria-label="First"><span aria-hidden="true">&laquo;</span></asp:LinkButton>
                </li>
                <asp:Repeater ID="rptPaging" runat="server"
                    OnItemCommand="rptPaging_ItemCommand"
                    OnItemDataBound="rptPaging_ItemDataBound">
                    <ItemTemplate>
                        <li>
                            <asp:LinkButton ID="lbPaging" runat="server"
                                CommandArgument='<%# Eval("PageIndex") %>'
                                CommandName="newPage"
                                Text='<%# Eval("PageText") %>'>
                            </asp:LinkButton>
                        </li>
                    </ItemTemplate>
                </asp:Repeater>

                <li class="next">
                    <asp:LinkButton ID="lbLast" runat="server" aria-label="Last"
                        OnClick="lbLast_Click"><span aria-hidden="true">&raquo;</span></asp:LinkButton>
                </li>
                <%--                    <li class="next">
                        <asp:LinkButton ID="lbLast" runat="server"
                            OnClick="lbLast_Click">Oldest</asp:LinkButton>
                    </li>--%>
            </ul>
        </nav>
    </asp:Panel>
    <div class="modal fade" id="confirm-DeletePost" tabindex="-1" role="dialog" aria-labelledby="confirm-DeletePostLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content alert-danger">

                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title" id="confirm-DeletePostLabel">Are you sure?</h4>
                </div>

                <div class="modal-body">
                    <p>Are you sure you want to delete this post?</p>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" formnovalidate>Cancel</button>
                    <asp:Button ID="btnDeletePost" runat="server" Text="Delete Post" CssClass="btn btn-danger" OnClick="btnDeletePost_Click" formnovalidate />
                    <%--<a class="btn btn-danger btn-ok">Delete Comment</a>--%>
                </div>
            </div>
        </div>
    </div>
    <script>
        $('#confirm-DeletePost').on('show.bs.modal', function (e) {
            $(<%=hdnPostToDelete.ClientID%>).val($(e.relatedTarget).data('href'));
        });
    </script>
</asp:Content>


